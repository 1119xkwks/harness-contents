# Typography 가이드

## 폰트 설정

### 기본 폰트
- **Noto Sans KR** (Google Fonts)
- 한글과 영문을 모두 지원하는 전문적인 산세리프 폰트
- `app/layout.tsx`에서 설정됨

```typescript
import { Noto_Sans_KR } from "next/font/google";

const notoSansKR = Noto_Sans_KR({
  subsets: ["latin"],
  weight: ["100", "300", "400", "500", "700", "900"],
});
```

---

## 폰트 Weight 규칙

**절대 'bold' 문자열을 사용하지 마세요!**

### 허용된 Weight 값

| Weight | 용도 | MUI sx prop | 사용 예 |
|--------|------|-----------------|--------|
| **400** | 본문, 일반 텍스트 | `font-normal` | 일반 설명, 본문 내용 |
| **500** | 강조 텍스트, 서브헤더 | `font-medium` | 카드 제목, 라벨 |
| **700** | 헤더, 주요 강조 | `font-bold` | 페이지 제목, 강조 텍스트 |

### 사용 금지

```html
<!-- ❌ 절대 금지 -->
<div style="font-weight: bold">텍스트</div>
<div style={{ fontWeight: "bold" }}>텍스트</div>
```

### 올바른 사용

```tsx
{/* ✅ MUI Typography / sx prop 사용 */}
<Typography sx={{ fontWeight: 400 }}>본문</Typography>
<Typography sx={{ fontWeight: 500 }}>강조</Typography>
<Typography sx={{ fontWeight: 700 }}>헤더</Typography>
```

---

## MUI Theme 설정

`providers.tsx`에서 MUI ThemeProvider로 폰트 설정:

```tsx
const theme = createTheme({
  typography: {
    fontFamily: '"Noto Sans KR", sans-serif',
    fontWeightRegular: 400,
    fontWeightMedium: 500,
    fontWeightBold: 700,
  },
});
```

---

## 텍스트 크기 규칙

| 용도 | MUI 사용법 | 크기 |
|------|-----------|------|
| 페이지 제목 | `<Typography variant="h5">` 또는 `sx={{ fontSize: 20 }}` | 20px / 24px |
| 섹션 제목 | `<Typography variant="h6">` 또는 `sx={{ fontSize: 18 }}` | 18px |
| 카드 제목 | `<Typography sx={{ fontSize: 16, fontWeight: 500 }}>` | 16px |
| 본문 | `<Typography variant="body2">` 또는 `sx={{ fontSize: 14 }}` | 14px |
| 보조 텍스트 | `<Typography variant="caption">` 또는 `sx={{ fontSize: 12 }}` | 12px |
| Breadcrumbs | `<Typography variant="caption">` | 12px |

### 사용 예시

```tsx
{/* 페이지 제목 */}
<Typography variant="h5" sx={{ fontWeight: 700, color: '#1a1a1a' }}>회원 목록</Typography>

{/* 카드 제목 */}
<Typography sx={{ fontSize: 16, fontWeight: 500, color: '#333' }}>총 회원수</Typography>

{/* 본문 */}
<Typography variant="body2" sx={{ color: '#666' }}>설명 텍스트입니다.</Typography>

{/* 보조 텍스트 */}
<Typography variant="caption" sx={{ color: '#999' }}>2026-04-12</Typography>
```

---

## 권장 사항

1. **일관성 유지**: 모든 텍스트는 400, 500, 700 중 하나의 weight를 사용
2. **가독성**: 너무 많은 weight를 섞어 사용하지 않기
3. **계층구조**: weight로 시각적 계층을 명확하게 표현
   - 제목: 700 (`sx={{ fontWeight: 700 }}`)
   - 서브제목: 500 (`sx={{ fontWeight: 500 }}`)
   - 본문: 400 (`sx={{ fontWeight: 400 }}`)

---

**마지막 수정**: 2026-04-12
