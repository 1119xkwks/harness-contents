# 레이아웃 구조 및 영역 구분

## 원칙

**모든 주요 영역은 명확한 구분선으로 구분되어야 합니다.**

각 영역의 경계를 시각적으로 명확하게 표현하여 사용자가 페이지 구조를 직관적으로 이해할 수 있도록 합니다.

---

## 레이아웃 구조

```
┌───────────────────────────────────────────┐
│  헤더 (AppBar)                            │  흰색 배경
├───────────────────────────────────────────┤  구분선: border-b border-[#d0d0d0]
│                                           │
│  ┌──────────────┬──────────────────────┐  │
│  │              │ ┌────────────────┐   │  │
│  │              │ │  Breadcrumbs   │   │  │  흰색 배경
│  │   사이드바   │ │  (대시보드/개요)│   │  │  구분선: border-b border-[#d0d0d0]
│  │ (bg-[#ececec])│ ├────────────────┤   │  │
│  │              │ │                │   │  │
│  │              │ │  본문 콘텐츠   │   │  │  bg-[#f5f5f5] 배경
│  │              │ │  (Cards, Grid) │   │  │
│  │              │ │                │   │  │
│  │              │ └────────────────┘   │  │
│  │              │                      │  │
│  └──────────────┴──────────────────────┘  │
│                                           │
└───────────────────────────────────────────┘
```

---

## 각 영역 상세

### 1. 헤더 (AppBar)

- **배경색**: `bg-white`
- **높이**: `h-16` (64px)
- **하단 구분선**: `border-b border-[#d0d0d0]`
- **내용**:
  - **좌측**: 모바일 메뉴 토글 버튼, 로고/제목
  - **우측**: 로그인 사용자명 표시 + **로그아웃 버튼**

#### 로그아웃 버튼

- **위치**: AppBar 우측 끝
- **형태**: 텍스트 버튼 (`text-sm text-gray-700 hover:text-black`)
- **라벨**: `로그아웃` 또는 `{사용자명} 님 | 로그아웃`
- **동작**:
  1. 클릭 시 `$confirm('로그아웃 하시겠습니까?')` 확인 모달
  2. 확인 → `POST /api/auth/logout` 호출
  3. Cookie 삭제 (`accessToken`, `refreshToken`)
  4. `/admin/login`으로 리다이렉트

```html
<header className="bg-white h-16 flex items-center px-4 border-b border-[#d0d0d0]">
  <!-- 좌측: 메뉴 토글 + 로고 -->
  <!-- 우측: 사용자명 + 로그아웃 -->
</header>
```

### 2. 사이드바

- **배경색**: `bg-[#ececec]`
- **너비**: `w-60` (240px, 데스크톱)
- **높이**: 전체 콘텐츠 영역 높이
- **구분**: 명확한 색상 차이로 본문과 구분
- **구분선**: 메뉴 항목 사이에 divider 포함

```html
<aside className="w-60 bg-[#ececec] flex flex-col flex-1">
  <!-- 메뉴 항목 -->
</aside>
```

### 3. 본문 영역

- **레이아웃**: `flex flex-col`
- **높이**: `h-[calc(100vh-64px)]` (헤더 높이 제외)
- **오버플로우**: `overflow-hidden` (자식 요소가 overflow 관리)

#### 3-1. Breadcrumbs 영역 (본문 상단)

- **배경색**: `bg-white`
- **패딩**: `px-4 py-1`
- **글자 크기**: `text-xs`
- **하단 구분선**: `border-b border-[#d0d0d0]`
- **용도**: 현재 페이지 경로 표시

```html
<nav className="bg-white px-4 py-1 border-b border-[#d0d0d0]">
  <ol className="flex items-center gap-1 text-xs text-gray-500">
    <li><a href="/" className="hover:text-gray-700">대시보드</a></li>
    <li>/</li>
    <li className="text-gray-800">개요</li>
  </ol>
</nav>
```

#### 3-2. 본문 콘텐츠 영역 (본문 하단)

- **배경색**: `bg-[#f5f5f5]`
- **패딩**: `p-6`
- **오버플로우**: `overflow-auto`
- **높이**: `flex-1`

```html
<main className="flex-1 bg-[#f5f5f5] p-6 overflow-auto">
  <div className="max-w-6xl mx-auto">
    <!-- 페이지 콘텐츠 -->
  </div>
</main>
```

---

## 색상 규칙

> 색상 원칙은 `docs/ui/color.md`를 참조합니다. 아래는 레이아웃 영역별 구체적 색상값입니다.

| 영역 | Tailwind 클래스 | HEX | 용도 |
|------|-----------------|-----|------|
| 헤더 | `bg-white` | #ffffff | AppBar 배경 |
| Breadcrumbs | `bg-white` | #ffffff | 네비게이션 배경 |
| 구분선 | `border-[#d0d0d0]` | #d0d0d0 | 모든 영역 경계 |
| 사이드바 | `bg-[#ececec]` | #ececec | 사이드바 배경 |
| 본문 | `bg-[#f5f5f5]` | #f5f5f5 | 콘텐츠 배경 |

---

## 구분선 가이드

### 올바른 사용

**각 주요 영역 경계에 구분선 사용:**

```html
<!-- 헤더 하단 -->
<header className="border-b border-[#d0d0d0]">...</header>

<!-- Breadcrumbs 하단 -->
<nav className="border-b border-[#d0d0d0]">...</nav>

<!-- 메뉴 항목 사이 -->
<hr className="border-[#d0d0d0]" />
```

### 금지

- 그림자(`shadow`)로 구분하지 말 것 (모호함)
- 색상으로만 구분하지 말 것 (명확하지 않음)
- 구분선 없이 영역을 분리하지 말 것

---

## 반응형 디자인

### 데스크톱 (`lg` 이상)

- 사이드바: `w-60` 고정 너비, 항상 표시
- 본문: 나머지 영역 차지 (`flex-1`)
- 모든 영역 경계에 구분선 표시

### 모바일 (`md` 이하)

- 사이드바: `hidden` (토글 시 오버레이로 표시)
- 헤더에 토글 버튼 표시
- Breadcrumbs와 본문 사이 구분선만 표시

```html
<!-- 사이드바: 모바일 숨김, 데스크톱 표시 -->
<aside className="hidden lg:flex w-60 bg-[#ececec] flex-col">
  ...
</aside>
```

---

## 마지막 수정

- **작성일**: 2026-04-10
- **최종 수정**: 2026-04-12
