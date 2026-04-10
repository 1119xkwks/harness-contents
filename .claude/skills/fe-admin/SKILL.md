---
name: fe-admin-setup
description: 프런트 앤드 관리자 페이지를 자동으로 생성하고 화면 검증까지 수행
trigger: /fe-admin-setup
---

# Fe Admin Dashboard Setup & Validation

## 설명

Layout Builder Agent를 이용하여 Fe Admin Dashboard를 완전히 구성합니다.

이 skill은 다음 작업을 자동으로 수행합니다:

1. **프로젝트 초기화** - Next.js 프로젝트 구조 확인
2. **필수 파일 생성** - 레이아웃, 컴포넌트, 문서 작성
3. **가이드라인 적용** - 색상, 타이포그래피, 레이아웃 규칙 문서화
4. **공통 컴포넌트** - Sidebar, MainLayout, Breadcrumbs 생성
5. **페이지 구성** - 대시보드/개요 페이지 완성
6. **메뉴 정의** - 2-depth 메뉴 구조 작성
7. **개발 서버 실행** - 포트 3001에서 서버 시작

## 사전 요구사항

- Next.js 14+ 프로젝트
- Node.js 18+
- npm 또는 yarn 패키지 매니저

## 생성되는 파일

### 레이아웃 & 컴포넌트
- `app/components/Sidebar.tsx` - 2-depth 메뉴 사이드바
- `app/components/MainLayout.tsx` - 공통 레이아웃 (헤더, 사이드바, breadcrumbs)
- `app/components/SidebarMenuButton.tsx` - 모바일 메뉴 토글

### 페이지
- `app/page.tsx` - 대시보드/개요 페이지

### 상수 & 설정
- `app/constants/menu.ts` - 메뉴 데이터 (2-depth 구조)
- `app/providers.tsx` - MUI ThemeProvider 설정
- `app/globals.css` - 글로벌 스타일

### 문서 & 가이드라인
- `docs/ui/color.md` - 색상 사용 규칙
- `docs/ui/typography.md` - 타이포그래피 규칙
- `docs/ui/layout.md` - 레이아웃 구조 가이드

## 실행 방법

```bash
# Skill 실행
/fe-admin-setup

# 처리 순서:
# 1. Layout Builder Agent 호출 → 모든 파일 생성
# 2. Layout Validator Agent 호출 → 자동 검증
# 3. 검증 리포트 생성
```

## 실행 흐름

```
사용자: /fe-admin-setup 트리거
         ↓
    Skill 시작
         ↓
    Layout Builder Agent ──→ 모든 파일 생성
         ↓
    Layout Validator Agent ──→ Chrome 확장 확인
         ↓                      (미설치 시 안내)
    개발 서버 시작 ──→ http://localhost:3001
         ↓
    자동 브라우저 연결
         ↓
    스크린샷 캡처
         ↓
    검증 실행 (색상, 구조, 기능)
         ↓
    ✅ 검증 리포트 출력
```

## Agent 작업 단계

### 1단계: 프로젝트 확인
- Next.js 구조 검증
- 필수 패키지 확인 (MUI, Tailwind CSS)

### 2단계: 레이아웃 생성
Layout Builder Agent 호출:
```
다음 규칙을 따라 Fe Admin Dashboard 레이아웃을 완성해줘:
- docs/ui/layout.md의 구조를 따름
- MainLayout 컴포넌트로 헤더, 사이드바, breadcrumbs 통합
- 모든 색상과 스타일 규칙 준수
```

### 3단계: 컴포넌트 생성
- **Sidebar.tsx**: 2-depth 메뉴, 동적 확장/축소
- **MainLayout.tsx**: 레이아웃 래퍼, breadcrumbs props 지원
- **menu.ts**: 메뉴 데이터 구조

### 4단계: 페이지 작성
- **page.tsx**: 대시보드/개요 페이지
- MainLayout으로 래핑
- 환영 메시지, 통계 카드, 액션 버튼 포함

### 5단계: 스타일 문서 작성
- **color.md**: 색상 규칙 (흰색, 그레이, 구분선)
- **typography.md**: 글자 가중치 (400/500/700)
- **layout.md**: 레이아웃 구조 다이어그램

### 6단계: 검증 및 실행
- 모든 파일 생성 확인
- 빌드 에러 확인
- 개발 서버 실행 (포트 3001)

## 생성되는 레이아웃 구조

```
┌────────────────────────────────────┐
│  Fe 관리자 대시보드                  │  AppBar (흰색)
├────────────────────────────────────┤  구분선
│  ┌──────────┬────────────────────┐ │
│  │          │ 대시보드 / 개요     │ │  Breadcrumbs
│  │ 사이드바 ├────────────────────┤ │  (흰색)
│  │ (#ececec)│                    │ │
│  │          │ 콘텐츠             │ │  Page Content
│  │          │ - 환영 메시지      │ │  (#f5f5f5)
│  │          │ - 통계 카드        │ │
│  │          │ - 빠른 실행        │ │
│  │          │                    │ │
│  └──────────┴────────────────────┘ │
└────────────────────────────────────┘
```

## 메뉴 구조 (2-depth)

```
📊 대시보드
  ├─ 개요
  └─ 통계

👥 사용자 관리
  ├─ 사용자 목록
  └─ 권한 관리

📈 리포트
  ├─ 판매 리포트
  └─ 성능 분석

⚙️ 설정
  ├─ 계정 설정
  ├─ 보안 설정
  └─ 시스템 설정
```

## 색상 팔레트

| 용도 | 색상 | HEX | 사용처 |
|------|------|-----|--------|
| 헤더 | 흰색 | #ffffff | AppBar |
| 사이드바 | 다크 그레이 | #ececec | 사이드바 배경 |
| 콘텐츠 | 라이트 그레이 | #f5f5f5 | 페이지 배경 |
| 구분선 | 라이트 그레이 | #d0d0d0 | 모든 영역 경계 |
| 강조 | 파랑 | #1976d2 | 버튼, 링크 |

## 자동 검증 프로세스

### 1단계: Chrome Claude Code 확장 확인

```
[자동 체크]
- Claude Code 확장 설치 여부 확인
- 설치 안 됨 → 설치 안내 제공
- 설치 됨 → 다음 단계 진행
```

**설치 필요한 경우:**
```
🔗 Chrome 확장 설치 링크:
https://chromewebstore.google.com/detail/claude-code/...

또는:
1. Chrome > 확장 프로그램 > 확장 프로그램 관리
2. "Claude Code" 검색
3. "추가" 클릭
```

### 2단계: 개발 서버 시작

```
[자동 실행]
npm run dev --port 3001
```

서버 상태:
- ✅ 포트 3001에서 실행 중
- ✅ 빌드 성공 확인
- ⚠️ 실패 시 에러 메시지 표시

### 3단계: 브라우저 자동 연결

```
[자동 처리]
1. Claude Code 확장 활성화 확인
2. http://localhost:3001 자동 로드
3. 페이지 렌더링 대기 (3초)
```

필요한 경우:
- Claude Code 확장 아이콘 클릭 후 "Connect" 선택

### 4단계: 화면 검증 (자동)

```
[자동 스크린샷 & 검증]
```

**검증 항목:**

| 항목 | 상태 | 확인 |
|------|------|------|
| 헤더 (AppBar) 표시 | ✅ | 흰색 배경, #d0d0d0 구분선 |
| 사이드바 표시 | ✅ | #ececec 배경, 메뉴 항목 보임 |
| Breadcrumbs 표시 | ✅ | "대시보드 / 개요" 표시 |
| 페이지 콘텐츠 | ✅ | #f5f5f5 배경, 통계 카드 |
| 메뉴 확장/축소 | ✅ | 클릭으로 동작 |
| 모바일 반응형 | ✅ | 375px에서 토글 버튼 표시 |
| 색상 규칙 | ✅ | 가이드라인 준수 |
| 글자 크기 | ✅ | breadcrumbs 0.75rem |

### 5단계: 검증 결과 리포트

```
✅ Fe Admin Dashboard 생성 완료

[검증 결과]
✓ 헤더 구분선 확인됨
✓ 사이드바 색상 (#ececec) 확인됨
✓ Breadcrumbs 표시 확인됨
✓ 콘텐츠 영역 (#f5f5f5) 확인됨
✓ 메뉴 동작 확인됨
✓ 모바일 반응형 확인됨

[생성된 파일]
✓ app/components/Sidebar.tsx
✓ app/components/MainLayout.tsx
✓ app/page.tsx
✓ app/constants/menu.ts
✓ docs/ui/color.md
✓ docs/ui/typography.md
✓ docs/ui/layout.md

서버: http://localhost:3001 (실행 중)
```

## 수동 검증

자동 검증 후에도 다음을 수동으로 확인해주세요:

```
1. 메뉴 클릭 테스트
   - 대시보드 > 개요 클릭
   - 사용자 관리 > 사용자 목록 클릭
   
2. Breadcrumbs 클릭
   - "대시보드" 클릭 후 홈으로 이동 확인
   
3. 모바일 반응형
   - 브라우저 개발자도구 (F12)
   - 디바이스 토글 (375px)
   - 메뉴 버튼 클릭 후 사이드바 표시 확인
   
4. 색상 확인
   - 헤더: 흰색 (#ffffff)
   - 사이드바: 다크 그레이 (#ececec)
   - 콘텐츠: 라이트 그레이 (#f5f5f5)
   - 구분선: 라이트 그레이 (#d0d0d0)
```

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

**마지막 수정**: 2026-04-10  
**버전**: 1.0  
**상태**: 준비 완료
