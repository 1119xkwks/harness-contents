---
name: fe-admin-setup
description: 프런트 앤드 관리자 페이지를 자동으로 생성하고 화면 검증까지 수행
trigger: /fe-admin-setup
---

# 관리자 FE 페이지 Setup & Validation

## 설명

**Layout Builder Agent**를 호출하여 관리자 FE 페이지를 완전히 구성합니다.

이 skill은 다음 순서로 진행됩니다:

1. **Layout Builder Agent 호출** - 모든 파일 생성 및 레이아웃 완성
2. **빌드 검증** - npm run build로 에러 확인
3. **화면 자동 검증** - Claude in Chrome으로 UI 검증
4. **Layout Validator Agent 호출** - 가이드라인 준수 검증
5. **최종 리포트** - 생성된 파일 목록, 화면 검증, 가이드라인 준수 여부 출력

## 에이전트 구성

| 에이전트 | 파일 | 역할 | 타입 |
|---------|------|------|------|
| Layout Builder | `.claude/agents/layout-builder.md` | 관리자 FE 페이지 레이아웃, 컴포넌트, 페이지, 가이드라인 생성 | general-purpose |
| Layout Validator | `.claude/agents/layout-validator.md` | 생성된 파일이 docs/ui/ 가이드라인 준수하는지 검증 | general-purpose |

## 사전 요구사항

- Next.js 14+ 프로젝트
- Node.js 18+
- npm 또는 yarn 패키지 매니저

## 실행 흐름

```
사용자: /fe-admin-setup
         ↓
Layout Builder Agent 호출 (`.claude/agents/layout-builder.md` 참조)
         ↓
npm install && npm run build
         ↓
자동 화면 검증 (Claude in Chrome)
         ↓
Layout Validator Agent 호출 (`.claude/agents/layout-validator.md` 참조)
         ↓
✅ 최종 리포트 (화면 검증 + 가이드라인 준수 검증)
```

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

4. **가이드라인 준수 검증**: Layout Validator Agent로 다음 검증
   - ✅ 색상 가이드라인 (color.md) 준수
   - ✅ 타이포그래피 가이드라인 (typography.md) 준수
   - ✅ 레이아웃 가이드라인 (layout.md) 준수

5. **최종 리포트** - `reports/` 경로에 markdown 파일로 생성
   - `reports/layout-validator-report.md`: Layout Validator 검증 결과

## Layout Builder Agent 활용

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

### 1단계: Layout Builder Agent 호출
`.claude/agents/layout-builder.md`에 정의된 Layout Builder Agent를 호출하여 모든 파일 생성

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

### 5단계: Layout Validator Agent 호출
`.claude/agents/layout-validator.md`에 정의된 Layout Validator Agent를 호출하여 다음 검증:
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
**상태**: Layout Validator Agent 추가됨
