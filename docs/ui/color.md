# 색상 규칙

## 레이아웃 색상 원칙

**레이아웃을 크게 잡을 때는 색상을 넣지 마세요.**

### 적용 범위

대규모 배경 영역 (헤더, 푸터, 사이드바 등 큰 컨테이너)에는 색상 없이 중립적인 색상을 사용합니다.

### 허용되는 색상

- **흰색** (`bg-white`, #ffffff)
- **회색 계열** (`bg-gray-100` ~ `bg-gray-200`, `bg-[#ececec]`, `bg-[#f5f5f5]`)
- **검은색** (`text-black`, #000000)

### 사용 금지

큰 레이아웃 영역에 primary, secondary 등 강렬한 브랜드 색상 사용 금지

### 예시

#### 올바른 사용

```html
<!-- 헤더 -->
<header className="bg-white text-black border-b border-[#d0d0d0]">
  ...
</header>

<!-- 사이드바 -->
<aside className="bg-[#ececec]">
  ...
</aside>

<!-- 본문 -->
<main className="bg-[#f5f5f5]">
  ...
</main>
```

#### 금지

```html
<!-- ❌ 큰 영역에 강렬한 색상 사용 금지 -->
<header className="bg-blue-600">...</header>
<aside className="bg-indigo-500">...</aside>
```

---

**마지막 수정**: 2026-04-12
