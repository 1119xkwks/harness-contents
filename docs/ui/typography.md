# Typography 가이드

## 폰트 설정

### 기본 폰트
- **Noto Sans KR** (Google Fonts)
- 한글과 영문을 모두 지원하는 전문적인 산세리프 폰트
- `app/layout.tsx`에서 설정됨

```typescript
import { Noto_Sans_KR } from "next/font/google";

const notoSansKR = Noto_Sans_KR({
  subsets: ["latin", "korean"],
  weight: ["100", "300", "400", "500", "700", "900"],
});
```

---

## 폰트 Weight 규칙

**절대 'bold' 문자열을 사용하지 마세요!**

### 허용된 Weight 값

| Weight | 용도 | Tailwind | React/MUI | 사용 예 |
|--------|------|----------|-----------|--------|
| **400** | 본문, 일반 텍스트 | `font-normal` | `fontWeight: 400` | 일반 설명, 본문 내용 |
| **500** | 강조 텍스트, 서브헤더 | `font-medium` | `fontWeight: 500` | 카드 제목, 라벨 |
| **700** | 헤더, 주요 강조 | `font-bold` | `fontWeight: 700` | 페이지 제목, 강조 텍스트 |

### 사용 금지

❌ **하지 말아야 할 방법:**
```typescript
// ❌ 절대 금지
<Typography fontWeight="bold">텍스트</Typography>
<div style={{ fontWeight: "bold" }}>텍스트</div>
<div className="font-bold">텍스트</div>  // Tailwind의 font-bold도 사용 가능하지만 명시적 값 권장
```

✅ **올바른 방법:**
```typescript
// Tailwind CSS
<Typography fontWeight={700}>텍스트</Typography>
<Typography fontWeight={500}>텍스트</Typography>
<Typography fontWeight={400}>텍스트</Typography>

// 또는 Tailwind 클래스
<div className="font-normal">본문</div>    // 400
<div className="font-medium">강조</div>    // 500
<div className="font-bold">헤더</div>      // 700
```

---

## Tailwind CSS 설정

`app/globals.css`에서 정의된 custom font weights:

```css
@theme inline {
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;
}
```

---

## MUI Typography 사용 예

```typescript
import { Typography } from "@mui/material";

// 본문 (400)
<Typography variant="body1" fontWeight={400}>
  일반 본문 텍스트
</Typography>

// 강조 텍스트 (500)
<Typography variant="body1" fontWeight={500}>
  강조된 텍스트
</Typography>

// 헤더 (700)
<Typography variant="h6" fontWeight={700}>
  헤더 텍스트
</Typography>
```

---

## 권장 사항

1. **일관성 유지**: 모든 텍스트는 400, 500, 700 중 하나의 weight를 사용
2. **가독성**: 너무 많은 weight를 섞어 사용하지 않기
3. **계층구조**: weight로 시각적 계층을 명확하게 표현
   - 제목: 700
   - 서브제목: 500
   - 본문: 400

---

**마지막 수정**: 2026-04-10
