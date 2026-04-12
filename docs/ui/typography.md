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

| Weight | 용도 | Tailwind 클래스 | 사용 예 |
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

```html
<!-- ✅ Tailwind 클래스 사용 -->
<div className="font-normal">본문</div>     <!-- 400 -->
<div className="font-medium">강조</div>     <!-- 500 -->
<div className="font-bold">헤더</div>       <!-- 700 -->
```

---

## Tailwind CSS 설정

`globals.css`에서 정의된 custom font weights:

```css
@theme inline {
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-bold: 700;
}
```

---

## 텍스트 크기 규칙

| 용도 | Tailwind 클래스 | 크기 |
|------|-----------------|------|
| 페이지 제목 | `text-xl` 또는 `text-2xl` | 20px / 24px |
| 섹션 제목 | `text-lg` | 18px |
| 카드 제목 | `text-base font-medium` | 16px |
| 본문 | `text-sm` | 14px |
| 보조 텍스트 | `text-xs` | 12px |
| Breadcrumbs | `text-xs` | 12px |

### 사용 예시

```html
<!-- 페이지 제목 -->
<h1 className="text-xl font-bold text-gray-900">회원 목록</h1>

<!-- 카드 제목 -->
<h3 className="text-base font-medium text-gray-800">총 회원수</h3>

<!-- 본문 -->
<p className="text-sm font-normal text-gray-600">설명 텍스트입니다.</p>

<!-- 보조 텍스트 -->
<span className="text-xs text-gray-400">2026-04-12</span>
```

---

## 권장 사항

1. **일관성 유지**: 모든 텍스트는 400, 500, 700 중 하나의 weight를 사용
2. **가독성**: 너무 많은 weight를 섞어 사용하지 않기
3. **계층구조**: weight로 시각적 계층을 명확하게 표현
   - 제목: 700 (`font-bold`)
   - 서브제목: 500 (`font-medium`)
   - 본문: 400 (`font-normal`)

---

**마지막 수정**: 2026-04-12
