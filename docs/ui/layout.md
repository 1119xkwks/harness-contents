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

- **배경색**: `#ffffff`
- **높이**: 64px
- **하단 구분선**: `borderBottom: '1px solid #d0d0d0'`
- **내용**:
  - **좌측**: 모바일 메뉴 토글 버튼, 로고/제목
  - **우측**: 로그인 사용자명 표시 + **로그아웃 버튼**

#### 로그아웃 버튼

- **위치**: AppBar 우측 끝
- **형태**: MUI Button (`variant="text"`, `sx={{ fontSize: 14, color: '#555' }}`)
- **라벨**: `로그아웃` 또는 `{사용자명} 님 | 로그아웃`
- **동작**:
  1. 클릭 시 `$confirm('로그아웃 하시겠습니까?')` 확인 모달
  2. 확인 → `POST /api/auth/logout` 호출
  3. Cookie 삭제 (`accessToken`, `refreshToken`)
  4. `/admin/login`으로 리다이렉트

```tsx
<AppBar position="static" sx={{ bgcolor: '#fff', color: '#000', height: 64, borderBottom: '1px solid #d0d0d0', boxShadow: 'none' }}>
  <Toolbar>{/* 좌측: 메뉴 토글 + 로고, 우측: 사용자명 + 로그아웃 */}</Toolbar>
</AppBar>
```

### 2. 사이드바

- **배경색**: `#ececec`
- **너비**: 240px (데스크톱)
- **높이**: 전체 콘텐츠 영역 높이
- **구분**: 명확한 색상 차이로 본문과 구분
- **구분선**: 메뉴 항목 사이에 MUI Divider 포함

```tsx
<Drawer variant="permanent" sx={{ width: 240, '& .MuiDrawer-paper': { width: 240, bgcolor: '#ececec' } }}>
  {/* 메뉴 항목 */}
</Drawer>
```

### 3. 본문 영역

- **레이아웃**: `display: 'flex', flexDirection: 'column'`
- **높이**: `height: 'calc(100vh - 64px)'` (헤더 높이 제외)
- **오버플로우**: `overflow: 'hidden'` (자식 요소가 overflow 관리)

#### 3-1. Breadcrumbs 영역 (본문 상단)

- **배경색**: `#ffffff`
- **패딩**: `px: 2, py: 0.5`
- **글자 크기**: 12px
- **하단 구분선**: `borderBottom: '1px solid #d0d0d0'`
- **용도**: 현재 페이지 경로 표시

```tsx
<Box sx={{ bgcolor: '#fff', px: 2, py: 0.5, borderBottom: '1px solid #d0d0d0' }}>
  <Breadcrumbs sx={{ fontSize: 12 }}>
    <Link href="/">대시보드</Link>
    <Typography sx={{ fontSize: 12, color: '#333' }}>개요</Typography>
  </Breadcrumbs>
</Box>
```

#### 3-2. 본문 콘텐츠 영역 (본문 하단)

- **배경색**: `#f5f5f5`
- **패딩**: 24px
- **오버플로우**: `overflow: 'auto'`
- **높이**: `flex: 1`

```tsx
<Box component="main" sx={{ flex: 1, bgcolor: '#f5f5f5', p: 3, overflow: 'auto' }}>
  <Box sx={{ maxWidth: 1152, mx: 'auto' }}>
    {/* 페이지 콘텐츠 */}
  </Box>
</Box>
```

---

## 색상 규칙

> 색상 원칙은 `docs/ui/color.md`를 참조합니다. 아래는 레이아웃 영역별 구체적 색상값입니다.

| 영역 | MUI sx prop | HEX | 용도 |
|------|-------------|-----|------|
| 헤더 | `bgcolor: '#fff'` | #ffffff | AppBar 배경 |
| Breadcrumbs | `bgcolor: '#fff'` | #ffffff | 네비게이션 배경 |
| 구분선 | `borderColor: '#d0d0d0'` | #d0d0d0 | 모든 영역 경계 |
| 사이드바 | `bgcolor: '#ececec'` | #ececec | 사이드바 배경 |
| 본문 | `bgcolor: '#f5f5f5'` | #f5f5f5 | 콘텐츠 배경 |

---

## 구분선 가이드

### 올바른 사용

**각 주요 영역 경계에 구분선 사용:**

```tsx
{/* 헤더 하단 */}
<AppBar sx={{ borderBottom: '1px solid #d0d0d0' }}>...</AppBar>

{/* Breadcrumbs 하단 */}
<Box sx={{ borderBottom: '1px solid #d0d0d0' }}>...</Box>

{/* 메뉴 항목 사이 */}
<Divider sx={{ borderColor: '#d0d0d0' }} />
```

### 금지

- 그림자(`shadow`)로 구분하지 말 것 (모호함)
- 색상으로만 구분하지 말 것 (명확하지 않음)
- 구분선 없이 영역을 분리하지 말 것

---

## 반응형 디자인

### 데스크톱 (`lg` 이상, 1200px+)

- 사이드바: 240px 고정 너비, 항상 표시 (MUI Drawer `variant="permanent"`)
- 본문: 나머지 영역 차지 (`flex: 1`)
- 모든 영역 경계에 구분선 표시

### 모바일 (`md` 이하, 900px 미만)

- 사이드바: 숨김 (MUI Drawer `variant="temporary"`, 토글 시 오버레이)
- 헤더에 토글 버튼 표시 (MUI IconButton)
- Breadcrumbs와 본문 사이 구분선만 표시

```tsx
{/* 사이드바: 데스크톱 permanent, 모바일 temporary */}
<Drawer
  variant={{ xs: 'temporary', lg: 'permanent' }}
  sx={{ width: 240, '& .MuiDrawer-paper': { width: 240, bgcolor: '#ececec' } }}
>
  ...
</Drawer>
```

---

## 마지막 수정

- **작성일**: 2026-04-10
- **최종 수정**: 2026-04-12
