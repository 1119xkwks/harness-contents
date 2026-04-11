---
name: projs-setup
description: 프런트 앤드 관리자 페이지를 자동으로 생성하고 화면 검증까지 수행
trigger: /projs-setup
---

# 관리자 FE 페이지 Setup & Validation

웹앱의 요구사항→설계→프론트엔드→백엔드→테스트를 에이전트 팀이 협업하여 개발한다.

## 실행 모드

**에이전트 팀** — 5명이 SendMessage로 직접 통신하며 교차 검증한다.

## 에이전트 구성

| 에이전트 | 파일 | 역할 | 타입 |
|---------|------|------|------|
| 사전 정보 인터뷰 | `.claude/agents/pre-interview.md` | DB 정보, 운영 포트 정보 얻기 | general-purpose |
| 관리자 FE 개발자 | `.claude/agents/frontend-developer.md` | 관리자 FE 페이지 레이아웃, 컴포넌트, 페이지, 가이드라인 생성 | general-purpose |
| 관리자 BE 개발자 | `.claude/agents/backend-developer.md` | 관리자 BE 프로젝트 생성, MyBatis로 DB 연결 | general-purpose |
| QA 검증 | `.claude/agents/qa.md` | FE/BE 코드 품질 및 컨벤션 규칙 검증 | general-purpose |

## 팀 구성 및 실행

팀을 구성하고 작업을 할당한다. 작업 간 의존 관계는 다음과 같다:

| 순서 | 작업 | 담당 | 의존 | 산출물 |
|------|------|------|------|--------|
| 1 | 사전 인터뷰 | 정보 얻기 | 없음 | `reports/01-pre-interview.md` |
| 2a | 관리자 프론트엔드 개발 | frontend | 작업 1 | `projs/fe-next` 프론트앤드 코드 |
| 2c | 관리자 백엔드 개발 | backend | 작업 1 | `projs/be-springboot` 백엔드 코드 |
| 3 | 사용자 확인 (DB 세팅) | 사용자 | 작업 2a, 2c | DB 테이블 생성 완료 |
| 4 | QA 검증 & 테스트 | qa | 작업 3 | `reports/qa.md`, 테스트 코드 |

작업 2a(관리자 프론트엔드 개발), 2c( 관리자 백엔드 개발)는 **병렬 실행**한다. 모두 작업 1(사전 인터뷰)에만 의존한다.

### 작업 3: 사용자 확인 (QA 전 필수 게이트)

코드 생성이 완료되면 QA 실행 **전에** 사용자에게 다음을 확인받는다:

1. **`application.yml` DB 접속 정보 확인** — 사전 인터뷰에서 받은 정보가 올바르게 설정되었는지 확인 요청
2. **`docs/db/create-tables.sql` 직접 실행 요청** — 사용자가 DB 클라이언트(pgAdmin, DBeaver 등)에서 직접 DDL을 실행
3. **테이블 생성 완료 확인** — 사용자가 "완료" 응답할 때까지 대기

> **⚠ 금지: `create-tables.sql`을 에이전트가 직접 실행하지 않는다.** DB 스키마 변경은 반드시 사용자가 수동으로 수행한다.

사용자 확인이 완료된 후 작업 4(QA)를 진행한다.

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

4. **가이드라인 준수 검증**: QA 검증 에이전트로 다음 검증
   - ✅ 색상 가이드라인 (color.md) 준수
   - ✅ 타이포그래피 가이드라인 (typography.md) 준수
   - ✅ 레이아웃 가이드라인 (layout.md) 준수

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

### 의존성 설치 & 빌드 검증
```bash
cd projs/fe-next
npm install && npm run build
```

---

**마지막 수정**: 2026-04-11  
**버전**: 1.2  
**상태**: FE/BE 검증 통합 (QA 에이전트)
