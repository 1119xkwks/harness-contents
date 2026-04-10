# Layout Validator Agent

## 역할

관리자 FE 페이지의 모든 파일이 `docs/ui/` 가이드라인을 올바르게 준수하고 있는지 검증합니다.

## 책임

### 1. 색상 가이드라인 (color.md) 검증

**검증 항목**:
- [ ] CSS 변수 정의 확인 (app/globals.css)
  - `--primary-color: #3b82f6`
  - `--primary-light: #60a5fa`
  - `--primary-dark: #1e40af`
  - `--secondary-color: #8b5cf6`
  - `--success-color: #10b981`
  - `--warning-color: #f59e0b`
  - `--error-color: #ef4444`
  - `--info-color: #06b6d4`

- [ ] 각 컴포넌트/페이지에서 색상 사용 검증
  - Primary 색상 사용: 버튼, 링크, 활성 메뉴, 강조 요소
  - Secondary 색상 사용: 보조 버튼, 배지, 라벨
  - Status 색상 사용: 성공/경고/오류/정보 메시지

- [ ] 파일별 검증
  - `app/providers.tsx`: MUI 테마 색상 정의
  - `app/globals.css`: CSS 변수 및 글로벌 색상
  - `app/components/Sidebar.tsx`: Sidebar 색상 (배경 #1f2937, 텍스트 #f3f4f6)
  - `app/components/MainLayout.tsx`: AppBar 색상 (배경 #ffffff)
  - `app/page.tsx`: 통계 카드 색상 (좌측 경계 색상)
  - `docs/ui/color.md`: 색상 가이드라인 문서

### 2. 타이포그래피 가이드라인 (typography.md) 검증

**검증 항목**:
- [ ] 폰트 패밀리 확인
  - "Geist" 또는 시스템 폰트 체인 사용

- [ ] 제목 스타일 검증
  - H1: 2.25rem(36px), 700, 라인높이 1.2
  - H2: 1.875rem(30px), 700, 라인높이 1.33
  - H3: 1.5rem(24px), 600, 라인높이 1.4
  - H4: 1.25rem(20px), 600, 라인높이 1.5
  - H5: 1.125rem(18px), 600, 라인높이 1.55
  - H6: 1rem(16px), 600, 라인높이 1.6

- [ ] 본문 스타일 검증
  - Body 1: 1rem(16px), 400, 라인높이 1.5
  - Body 2: 0.875rem(14px), 400, 라인높이 1.43
  - Caption: 0.75rem(12px), 400, 라인높이 1.67

- [ ] 버튼 텍스트
  - 0.9375rem(15px), 600

- [ ] 색상 준수
  - 주요 제목: #111827
  - 본문: #374151
  - 보조 텍스트: #6b7280

- [ ] 파일별 검증
  - `app/globals.css`: 글로벌 타이포그래피 스타일
  - `app/providers.tsx`: MUI 타이포그래피 설정
  - `app/components/Sidebar.tsx`: 메뉴 텍스트 크기 (0.9375rem)
  - `app/components/MainLayout.tsx`: AppBar 제목 스타일
  - `app/page.tsx`: 제목, 본문, 라벨 스타일
  - `docs/ui/typography.md`: 타이포그래피 가이드라인 문서

### 3. 레이아웃 가이드라인 (layout.md) 검증

**검증 항목**:
- [ ] Sidebar 스타일
  - 너비: 280px (데스크톱)
  - 위치: fixed, left: 0, top: 0
  - Z-index: 40
  - 배경: #1f2937
  - 텍스트: #f3f4f6
  - 헤더 높이: 60px
  - 메뉴 항목 높이: 44px, 패딩: 0.75rem 1.5rem
  - 활성 좌측 경계: 3px solid #3b82f6

- [ ] AppBar 스타일
  - 높이: 64px (데스크톱), 56px (모바일)
  - 패딩: 1rem 2rem (데스크톱)
  - 배경: #ffffff
  - 보더: 하단 1px solid #e5e7eb
  - Z-index: 30

- [ ] Breadcrumbs 스타일
  - 패딩: 0.75rem 2rem (데스크톱)
  - 텍스트 크기: 0.875rem (14px)
  - 링크 색상: #3b82f6

- [ ] 콘텐츠 영역
  - 패딩: 2rem (데스크톱), 1rem (태블릿), 0.75rem (모바일)
  - 배경: #f9fafb
  - 좌측 마진: 280px (데스크톱)

- [ ] 카드 스타일
  - 배경: #ffffff
  - 보더 반경: 0.75rem
  - 패딩: 1.5rem (데스크톱), 1rem (모바일)
  - 그림자: 0 1px 3px rgba(0, 0, 0, 0.1)

- [ ] 그리드 시스템
  - 반응형 컬럼: repeat(auto-fit, minmax(280px, 1fr))
  - 갭: 1.5rem
  - 데스크톱: 4개 컬럼
  - 태블릿: 2개 컬럼
  - 모바일: 1개 컬럼

- [ ] 반응형 브레이크포인트
  - 768px 이상: 데스크톱 레이아웃
  - 768px ~ 480px: 태블릿 레이아웃
  - 480px 이하: 모바일 레이아웃

- [ ] MainLayout 사용
  - 모든 페이지에서 MainLayout 컴포넌트 사용
  - Breadcrumbs 전달
  - pageTitle 설정

- [ ] 파일별 검증
  - `app/components/Sidebar.tsx`: Sidebar 구조 및 스타일
  - `app/components/Sidebar.module.css`: Sidebar 스타일링
  - `app/components/MainLayout.tsx`: AppBar, Breadcrumbs, 콘텐츠 영역 구조
  - `app/components/MainLayout.module.css`: 레이아웃 스타일
  - `app/globals.css`: 브레이크포인트 및 반응형 스타일
  - `app/page.tsx`: MainLayout 사용, Breadcrumbs 설정
  - `app/page.module.css`: 페이지 스타일
  - `docs/ui/layout.md`: 레이아웃 가이드라인 문서

## 검증 프로세스

### 단계 1: 파일 구조 확인
- [ ] 필수 파일 존재 여부
- [ ] 파일 경로 정확성

### 단계 2: 색상 검증
- [ ] CSS 변수 정의 확인
- [ ] 각 파일에서 색상값 추출
- [ ] 가이드라인과의 일치도 확인
- [ ] 색상 사용 컨텍스트 검증 (일관성)

### 단계 3: 타이포그래피 검증
- [ ] 폰트 패밀리 확인
- [ ] 제목 태그 사용 검증
- [ ] 폰트 사이즈/웨이트/라인높이 확인
- [ ] 반응형 타이포그래피 검증

### 단계 4: 레이아웃 검증
- [ ] Sidebar/AppBar/Breadcrumbs 구조 확인
- [ ] CSS 크기/위치 값 검증
- [ ] 반응형 스타일 확인
- [ ] 그리드 시스템 검증
- [ ] MainLayout 사용 여부 확인

### 단계 5: 최종 리포트
- [ ] 준수 항목 요약
- [ ] 미준수 항목 목록
- [ ] 수정 권장사항

## 호출 프롬프트

```
프로젝트 경로: D:\dev\harness-contents\proj\fe-admin

다음을 검증해줘:

1. **색상 가이드라인 (docs/ui/color.md) 준수 검증**
   - app/globals.css의 CSS 변수 확인
   - app/providers.tsx의 MUI 테마 색상 확인
   - 각 컴포넌트/페이지에서 사용된 색상이 가이드라인 준수하는지 확인
   - Primary, Secondary, Status 색상 사용 일관성 검증

2. **타이포그래피 가이드라인 (docs/ui/typography.md) 준수 검증**
   - Geist 폰트 사용 확인
   - H1-H6 제목 스타일 (크기, 굵기, 라인높이) 검증
   - Body 본문 스타일 검증
   - 텍스트 색상 준수 검증
   - 반응형 타이포그래피 검증

3. **레이아웃 가이드라인 (docs/ui/layout.md) 준수 검증**
   - Sidebar 크기/위치/Z-index (280px, fixed, 40) 확인
   - AppBar 높이/패딩 (64px, 1rem 2rem) 검증
   - Breadcrumbs 스타일 검증
   - 콘텐츠 영역 패딩/배경 검증
   - 카드 스타일 검증
   - 그리드 시스템 검증
   - 반응형 브레이크포인트 (768px, 480px) 확인
   - MainLayout 사용 여부 확인

모든 파일을 검사하고 다음 형식으로 리포트를 D:\dev\harness-contents\reports\layout-validator-report.md에 작성해줘:

## ✅/❌ 검증 결과 리포트

### 색상 가이드라인 준수
- [상태] 항목: 상세 설명

### 타이포그래피 가이드라인 준수
- [상태] 항목: 상세 설명

### 레이아웃 가이드라인 준수
- [상태] 항목: 상세 설명

### 종합 평가
- 준수율: X%
- 미준수 항목: 목록
- 권장사항: 개선 사항

최종 결론: [완전 준수 / 부분 준수 / 미준수]
```

## 완료 조건
- ✅ 모든 파일 검증 완료
- ✅ 각 가이드라인별 준수 여부 판단
- ✅ 상세 리포트 작성
- ✅ 문제점 및 개선안 제시
