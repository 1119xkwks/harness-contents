---
name: fe-admin-setup
description: 프런트 앤드 관리자 페이지를 자동으로 생성하고 화면 검증까지 수행
trigger: /fe-admin-setup
---

# 관리자 FE 페이지 Setup & Validation

웹앱의 요구사항→설계→프론트엔드→백엔드→테스트를 에이전트 팀이 협업하여 개발한다.

## 실행 모드

**에이전트 팀** — 5명이 SendMessage로 직접 통신하며 교차 검증한다.

## 에이전트 구성

| 에이전트 | 파일 | 역할 | 타입 |
|---------|------|------|------|
| 사전 정보 인터뷰 | `.claude/agents/pre-interview.md` | DB 정보, 운영 포트 정보 얻기 | general-purpose |
| 관리자 FE 개발자 | `.claude/agents/admin-fe-developer.md` | 관리자 FE 페이지 레이아웃, 컴포넌트, 페이지, 가이드라인 생성 | general-purpose |
| 관리자 FE 검증자 | `.claude/agents/admin-fe-validator.md` | 생성된 파일이 docs/ui/ 가이드라인 준수하는지 검증 | general-purpose |
| 관리자 BE 개발자 | `.claude/agents/admin-be-developer.md` | 관리자 BE 프로젝트 생성, MyBatis로 DB 연결 | general-purpose |
| 관리자 BE 검증자 | `.claude/agents/admin-be-validator.md` | 관리자 BE 프로젝트 구조 및 컨벤션 규칙 파악 | general-purpose |

## 팀 구성 및 실행

팀을 구성하고 작업을 할당한다. 작업 간 의존 관계는 다음과 같다:

| 순서 | 작업 | 담당 | 의존 | 산출물 |
|------|------|------|------|--------|
| 1 | 사전 인터뷰 | 정보 얻기 | 없음 | `reports/01-pre-interview.md` |
| 2a | 관리자 프론트엔드 개발 | frontend | 작업 1 | `proj/fe-admin` 프론트앤드 코드 |
| 2b | 관리자 프론트엔드 검수 | frontend 검수 | 작업 2a | `reports/02-admin-fe-validator.md` |
| 2c | 관리자 백엔드 개발 | backand | 작업 1 | `proj/be-admin` 백엔드 코드 |
| 2d | 관리자 프론트엔드 검수 | backand 검수 | 작업 2c | `reports/03-admin-be-validator.md` |

작업 2a(관리자 프론트엔드 개발), 2c( 관리자 백엔드 개발)는 **병렬 실행**한다. 모두 작업 1(사전 인터뷰)에만 의존한다.

**팀원 간 소통 흐름:**
- 사전 인터뷰 완료 → frontend에게 컴포넌트 구조·라우팅 전달, backend에게 API·DB·인증 전달, qa에게 기능 요구사항 전달
- frontend ↔ backend: API 연동 중 실시간 소통 (엔드포인트 변경, 에러 형식 등)

## 자동 검증 프로세스

Skill 완료 후 자동으로 다음을 수행합니다:

1. **빌드 검증**: `npm run build`로 컴파일 에러 확인
2. **개발 서버 시작**: 포트 3001에서 Next.js 개발 서버 실행
3. **화면 검증**: Claude in Chrome으로 다음 항목 자동 확인
   - ✅ 헤더 (AppBar) 렌더링
   - ✅ 사이드바 메뉴 (4개 항목)
   - ✅ Breadcrumbs 표시
   - ✅ 통계 카드 (4개)
   - ✅ 메뉴 확장/축소 동작
   - ✅ 모바일 반응형 (375x812)

4. **가이드라인 준수 검증**: Admin FE Validator Agent로 다음 검증
   - ✅ 색상 가이드라인 (color.md) 준수
   - ✅ 타이포그래피 가이드라인 (typography.md) 준수
   - ✅ 레이아웃 가이드라인 (layout.md) 준수

## Admin FE Developer Agent 활용

이후 새로운 페이지를 추가할 때:

```
새로운 사용자 관리 페이지를 만들어줘
경로: app/dashboard/users/page.tsx
breadcrumbs: [대시보드, 사용자 관리]
```

Agent가 자동으로:
- docs/ui/ 가이드라인 준수
- MainLayout 적용
- 구조 및 스타일 동기화

## 주의사항

- ⚠️ 기존 파일을 덮어쓸 수 있습니다
- ⚠️ 포트 3001이 사용 중이면 변경 필요
- ⚠️ package.json에 MUI, Tailwind CSS가 설치되어 있어야 함

## 지원

문제 발생 시:
1. 콘솔 에러 메시지 확인
2. `app/providers.tsx`의 ThemeProvider 설정 확인
3. 파일 경로 및 import 확인

---

## 🎯 실행 명령

**이제 다음을 순서대로 수행합니다:**

### 1단계: Admin FE Developer Agent 호출
`.claude/agents/admin-fe-developer.md`에 정의된 Admin FE Developer Agent를 호출하여 모든 파일 생성

### 2단계: 의존성 설치 & 빌드 검증
```bash
cd proj/fe-admin
npm install && npm run build
```

### 3단계: 개발 서버 시작 (백그라운드)
```bash
npm run dev -- --port 3001
```

### 4단계: 자동 화면 검증
Claude in Chrome MCP로 다음 항목 확인:
- ✅ 헤더 (AppBar) 렌더링
- ✅ 사이드바 메뉴 및 확장/축소
- ✅ Breadcrumbs 표시
- ✅ 통계 카드 4개
- ✅ 모바일 반응형 (375x812)

### 5단계: Admin FE Validator Agent 호출
`.claude/agents/admin-fe-validator.md`에 정의된 Admin FE Validator Agent를 호출하여 다음 검증:
- ✅ 색상 가이드라인 (docs/ui/color.md) 준수
  - CSS 변수 정의 확인
  - Primary, Secondary, Status 색상 사용 검증
- ✅ 타이포그래피 가이드라인 (docs/ui/typography.md) 준수
  - Geist 폰트 사용 확인
  - H1-H6 제목 스타일 검증
  - 본문, 라벨 스타일 검증
- ✅ 레이아웃 가이드라인 (docs/ui/layout.md) 준수
  - Sidebar 크기/위치 (280px, fixed, Z-index 40)
  - AppBar 높이/패딩 (64px, 1rem 2rem)
  - 반응형 브레이크포인트 (768px, 480px)
  - MainLayout 사용 여부

### 6단계: 최종 리포트 생성
모든 리포트는 `reports/` 경로에 markdown 파일로 생성됩니다:
- `reports/layout-validator-report.md`: 가이드라인 준수 검증 결과
  - 색상 가이드라인 준수 여부
  - 타이포그래피 가이드라인 준수 여부
  - 레이아웃 가이드라인 준수 여부
  - 종합 평가 및 개선사항

---

**마지막 수정**: 2026-04-10  
**버전**: 1.1  
**상태**: Admin FE Validator Agent 적용됨
