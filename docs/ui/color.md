# 색상 규칙

## 레이아웃 색상 원칙

**레이아웃을 크게 잡을 때는 색상을 넣지 마세요.**

### 적용 범위

대규모 배경 영역 (헤더, 푸터, 사이드바 등 큰 컨테이너)에는 색상 없이 중립적인 색상을 사용합니다.

### 허용되는 색상

- **흰색** (`sx={{ bgcolor: '#ffffff' }}`)
- **회색 계열** (`sx={{ bgcolor: '#ececec' }}`, `sx={{ bgcolor: '#f5f5f5' }}`)
- **검은색** (`sx={{ color: '#000000' }}`)

### 사용 금지

큰 레이아웃 영역에 primary, secondary 등 강렬한 브랜드 색상 사용 금지

### 예시

#### 올바른 사용

```tsx
{/* 헤더 */}
<AppBar sx={{ bgcolor: '#fff', color: '#000', borderBottom: '1px solid #d0d0d0' }}>
  ...
</AppBar>

{/* 사이드바 */}
<Drawer sx={{ '& .MuiDrawer-paper': { bgcolor: '#ececec' } }}>
  ...
</Drawer>

{/* 본문 */}
<Box component="main" sx={{ bgcolor: '#f5f5f5' }}>
  ...
</Box>
```

#### 금지

```tsx
{/* ❌ 큰 영역에 강렬한 색상 사용 금지 */}
<AppBar sx={{ bgcolor: 'primary.main' }}>...</AppBar>
<Drawer sx={{ '& .MuiDrawer-paper': { bgcolor: '#5c6bc0' } }}>...</Drawer>
```

---

**마지막 수정**: 2026-04-12
