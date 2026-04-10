# 레이아웃 구조 및 영역 구분

## 원칙

**모든 주요 영역은 명확한 구분선으로 구분되어야 합니다.**

각 영역의 경계를 시각적으로 명확하게 표현하여 사용자가 페이지 구조를 직관적으로 이해할 수 있도록 합니다.

---

## 레이아웃 구조

```
┌───────────────────────────────────────────┐
│  헤더 (AppBar)                            │  흰색 배경
├───────────────────────────────────────────┤  구분선: 1px solid #d0d0d0
│                                           │
│  ┌──────────────┬──────────────────────┐  │
│  │              │ ┌────────────────┐   │  │
│  │              │ │  Breadcrumbs   │   │  │  흰색 배경
│  │   사이드바   │ │  (대시보드/개요)│   │  │  구분선: 1px solid #d0d0d0
│  │ (#ececec)    │ ├────────────────┤   │  │
│  │              │ │                │   │  │
│  │              │ │  본문 콘텐츠   │   │  │  #f5f5f5 배경
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

- **배경색**: `white` (#ffffff)
- **높이**: 64px (기본값)
- **하단 구분선**: `1px solid #d0d0d0`
- **내용**: 로고, 제목, 메뉴 버튼 등

```typescript
<AppBar
  sx={{
    backgroundColor: "white",
    color: "black",
    borderBottom: "1px solid #d0d0d0",
  }}
/>
```

### 2. 사이드바

- **배경색**: `#ececec` (다크 라이트 그레이)
- **너비**: 240px (데스크톱)
- **높이**: 전체 콘텐츠 영역 높이
- **구분**: 명확한 색상 차이로 본문과 구분
- **구분선**: 메뉴 항목 사이에 divider 포함

```typescript
<Box sx={{
  width: 240,
  backgroundColor: "#ececec",
  display: "flex",
  flexDirection: "column",
  flex: 1,
}}/>
```

### 3. 본문 영역

- **레이아웃**: Flexbox 세로 방향(column)으로 2개 섹션으로 구성
- **높이**: calc(100vh - 64px) (헤더 높이 제외)
- **오버플로우**: hidden (자식 요소가 overflow 관리)

```typescript
<Box sx={{
  flex: 1,
  display: "flex",
  flexDirection: "column",
  overflow: "hidden",
}}/>
```

#### 3-1. Breadcrumbs 영역 (본문 상단)

- **배경색**: `white` (#ffffff)
- **패딩**: `4px 16px` (최소한의 여백)
- **글자 크기**: `0.75rem` (매우 작음)
- **하단 구분선**: `1px solid #d0d0d0`
- **용도**: 현재 페이지 경로 표시
- **높이**: 자동 (콘텐츠 크기에 따름)

```typescript
<Box sx={{
  backgroundColor: "white",
  padding: "4px 16px",
  borderBottom: "1px solid #d0d0d0",
}}>
  <Breadcrumbs sx={{ margin: 0, padding: 0 }}>
    <Link color="inherit" href="/" sx={{ cursor: "pointer", fontSize: "0.75rem" }}>
      대시보드
    </Link>
    <Typography color="textSecondary" sx={{ fontSize: "0.75rem" }}>
      개요
    </Typography>
  </Breadcrumbs>
</Box>
```

#### 3-2. 본문 콘텐츠 영역 (본문 하단)

- **배경색**: `#f5f5f5` (라이트 그레이)
- **패딩**: 3 (24px)
- **오버플로우**: auto (스크롤 가능)
- **콘텐츠**: Container, Grid, Card, Typography 등으로 구성
- **높이**: 나머지 영역 (flex: 1)

```typescript
<Box sx={{
  flex: 1,
  backgroundColor: "#f5f5f5",
  padding: 3,
  overflow: "auto",
}}>
  <Container maxWidth="lg">
    <Grid container spacing={3}>
      {/* Card, 콘텐츠 등 */}
    </Grid>
  </Container>
</Box>
```

---

## 색상 규칙

| 영역 | 색상 | HEX | 용도 |
|------|------|-----|------|
| 헤더 | 흰색 | #ffffff | AppBar 배경 |
| Breadcrumbs | 흰색 | #ffffff | 네비게이션 배경 |
| 구분선 | 라이트 그레이 | #d0d0d0 | 모든 영역 경계 |
| 사이드바 | 다크 그레이 | #ececec | 사이드바 배경 |
| 본문 | 라이트 그레이 | #f5f5f5 | 콘텐츠 배경 |

---

## 구분선 가이드

### ✅ 올바른 사용

**각 주요 영역 경계에 구분선 사용:**

```typescript
// 헤더 하단
<AppBar sx={{ borderBottom: "1px solid #d0d0d0" }} />

// Breadcrumbs 하단
<Box sx={{ borderBottom: "1px solid #d0d0d0" }} />

// 메뉴 항목 사이
<Divider sx={{ my: 0 }} />
```

### ❌ 금지

- 그림자(`boxShadow`)로 구분하지 말 것 (모호함)
- 색상으로만 구분하지 말 것 (명확하지 않음)
- 구분선 없이 영역을 분리하지 말 것

---

## 반응형 디자인

### 데스크톱 (lg 이상)

- 사이드바: 240px 고정 너비, 항상 표시
- 본문: 나머지 영역 차지
- 모든 영역 경계에 구분선 표시

### 모바일 (md 이하)

- 사이드바: Drawer로 숨김
- 헤더에 토글 버튼 표시
- Breadcrumbs와 본문 사이 구분선만 표시
- 사이드바 표시 시 전체 화면 사용

---

## 마지막 수정

- **작성일**: 2026-04-10
- **최종 수정**: 2026-04-10
