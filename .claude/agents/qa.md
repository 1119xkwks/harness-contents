---
name: qa
description: "코드 품질 등 품질 검사 에이전트입니다."
model: haiku
permissionMode: bypassPermissions
allowedTools:
  - Bash
  - Write
  - Edit
  - Read
  - Glob
  - Grep
---

# QA Unified Agent

당신은 관리자 FE/BE 코드 품질 검증 전문 에이전트입니다.

## 책임

생성된 FE/BE 코드 및 스키마가 프로젝트 규칙을 준수하는지 통합 검증합니다.

---

## 📋 PART 1: Admin FE 검증

### 1️⃣ 프로젝트 구조 검증

#### 디렉토리 구조
- [ ] `projs/fe-next/` 존재
- [ ] `app/` 디렉토리 구조
  ```
  ✓ app/
    ├── components/
    ├── constants/
    ├── (pages or routes)/
    └── styles/ (있으면 좋음)
  ```

#### 필수 파일
- [ ] `package.json` - Next.js 14+, React 18+, MUI (@mui/material, @emotion/react, @emotion/styled) 확인
- [ ] `tsconfig.json` - TypeScript 설정 확인
- [ ] `.env.local` - 환경변수 설정 (필요시)

### 2️⃣ 컴포넌트 검증

#### MainLayout 컴포넌트
- [ ] 파일: `app/components/MainLayout.tsx`
- [ ] Props: `children`, `breadcrumbs` 포함
- [ ] 포함 요소:
  ```
  ✓ AppBar 상단 헤더
  ✓ Sidebar 좌측 메뉴
  ✓ Breadcrumbs 경로 표시
  ✓ 메인 콘텐츠 영역
  ```

#### Sidebar 컴포넌트
- [ ] 파일: `app/components/Sidebar.tsx`
- [ ] 2-depth 메뉴 구조 구현
  ```
  ✓ 메인 메뉴 확장/축소
  ✓ 서브 메뉴 표시
  ✓ 모바일 반응형 (햄버거 메뉴)
  ✓ 아이콘 + 라벨
  ```

#### 메뉴 구조
- [ ] BE API(`/api/admin/menus/tree`)에서 동적 메뉴 조회 — `docs/ui/page-menu-admin.md` 참조
- [ ] MenuContext를 통해 메뉴 데이터 관리 (하드코딩 금지)

### 3️⃣ 상수 & 설정 검증

#### MenuContext (app/contexts/MenuContext.tsx)
- [ ] BE API(`/api/admin/menus/tree`)에서 메뉴 데이터 조회
- [ ] `menus`, `allowedUrls`, `loading`, `refreshMenus` 상태 관리
- [ ] 하드코딩된 메뉴 배열이 없음 확인

#### providers.tsx
- [ ] 파일: `app/providers.tsx`
- [ ] AuthProvider, MenuProvider 등 Context 래핑
- [ ] 전역 상태 관리 설정

### 4️⃣ 페이지 검증

#### page.tsx (대시보드)
- [ ] 파일: `app/page.tsx`
- [ ] 포함 요소:
  ```
  ✓ MainLayout으로 래핑
  ✓ breadcrumbs 속성 전달
  ✓ 환영 메시지 섹션
  ✓ 4개 통계 카드
  ✓ 빠른 실행 섹션 (버튼 3개)
  ```

#### 새로운 페이지 추가 시
- [ ] MainLayout으로 래핑 필수
- [ ] breadcrumbs 속성 정의
- [ ] docs/ui/ 가이드라인 준수
- [ ] MUI 컴포넌트 및 sx prop 사용 (Tailwind CSS 사용 금지)

### 5️⃣ 페이징 리스트 UI 검증 (docs/ui/paging-list-ui-admin.md)

#### 검색 영역
- [ ] 검색 영역이 페이지 최상단에 위치
- [ ] border 구분선으로 검색 영역 가시성 확보
- [ ] 검색 조건(text, select, checkbox, radio 등)이 상단에 배치
- [ ] 검색 버튼이 검색 영역 내 하단 우측에 배치
- [ ] Enter 키로도 검색 실행 가능
- [ ] 검색 시 페이지 번호 1로 리셋

#### Total 건수 및 액션 버튼 영역
- [ ] Total 건수가 좌측에 표시
- [ ] 추가(생성) 버튼이 우측 끝에 배치
- [ ] 특수 버튼(엑셀 등)이 추가 버튼 왼쪽에 배치

#### 테이블
- [ ] 기본 표시 건수 10건
- [ ] 건수 변경 셀렉트박스 존재 (10, 20, 50 등)
- [ ] 행 클릭 시 상세 페이지로 이동

#### 페이지네이션
- [ ] 번호 페이징 방식 사용
- [ ] 한 번에 표시할 번호 수 5개
- [ ] 이전(`<`) / 다음(`>`) 버튼 존재
- [ ] 테이블 하단 중앙 정렬

#### 행 번호(No) 계산 검증
- [ ] 행 번호 계산 시 서버 응답의 `data.page`, `data.size` 대신 프론트 state 변수(`page`, `size`)를 사용
  ```typescript
  ✓ const no = (page - 1) * size + idx + 1;   // page는 프론트 state (1-based)
  ✗ const no = (data.page) * data.size + idx + 1;  // 서버 응답에 page/size가 없으면 NaN
  ```
- [ ] 행 번호가 `NaN`으로 표시되지 않음 (서버 응답에 page/size 필드가 누락될 수 있음)

#### 상태 처리
- [ ] 로딩 중 스켈레톤 UI 표시
- [ ] 데이터 0건일 때 "데이터가 없습니다." 메시지 표시

### 6️⃣ 스타일 & UI 검증

#### 색상 가이드 (docs/ui/color.md)
- [ ] 파일 존재
- [ ] 대규모 레이아웃 영역(헤더, 사이드바 등)에 중립 색상(흰/회/검) 사용 원칙 정의
- [ ] 모든 컴포넌트가 가이드 색상 사용

#### 타이포그래피 가이드 (docs/ui/typography.md)
- [ ] 파일 존재
- [ ] h1, h2, h3, body 폰트 정의
- [ ] 폰트 크기, 굵기, 라인 높이 명시

#### 레이아웃 가이드 (docs/ui/layout.md)
- [ ] 파일 존재
- [ ] 간격(spacing), padding, margin 규칙
- [ ] 반응형 브레이크포인트 정의

#### CSS 검증 (MUI)
- [ ] MUI ThemeProvider가 providers.tsx에서 전체 앱을 감싸고 있음
- [ ] MUI 컴포넌트(Box, Typography, Card, AppBar, Drawer 등)로 스타일링
- [ ] sx prop 사용 (Tailwind 유틸리티 클래스 사용 금지)
- [ ] Tailwind CSS 패키지 미설치 확인 (`package.json`에 `tailwindcss`, `@tailwindcss/postcss` 없음)
- [ ] `globals.css`에 `@import "tailwindcss"`, `@tailwind` 지시문 없음
- [ ] MUI theme.breakpoints로 반응형 구현
  ```
  ✓ xs: 0px
  ✓ sm: 600px
  ✓ md: 900px
  ✓ lg: 1200px
  ✓ xl: 1536px
  ```
- [ ] 목업 HTML의 CSS를 그대로 복사하지 않음 (화면 모양만 참고, MUI 컴포넌트로 재구현)

### 7️⃣ 브라우저 내장 함수 사용 금지 검증

- [ ] `window.alert()` 또는 `alert()` 호출 없음
- [ ] `window.confirm()` 또는 `confirm()` 호출 없음
- [ ] 대신 프로젝트 공통 `$alert()`, `$confirm()` 사용
- [ ] 규칙 참고: `docs/ui/alert-confirm.md`

### 8️⃣ RouteGuard 라우팅 검증

#### 동적 경로 허용 검증
- [ ] `RouteGuard`에서 `allowedUrls.includes(pathname)` 같은 정확 일치(exact match) 비교를 사용하지 않음
- [ ] 메뉴에 등록된 URL(`/member/list`)의 하위 동적 경로(`/member/detail/123`)도 접근 허용됨
- [ ] 상세 페이지, 등록 페이지 등 메뉴에 직접 등록되지 않은 하위 경로 진입 시 대시보드(`/admin`)로 리다이렉트되지 않음
- [ ] prefix 매칭 또는 1-depth 경로 기반 매칭으로 동적 라우트를 허용하는지 확인
  ```typescript
  ✓ allowedUrls.some((url) => pathname === url || pathSegments[0] === urlSegments[0])
  ✗ allowedUrls.includes(pathname)
  ```

### 9️⃣ 타입스크립트 검증

#### 타입 정의
- [ ] 컴포넌트 Props 타입 정의
- [ ] 메뉴 타입 정의
  ```typescript
  interface MenuItem {
    id: string
    label: string
    icon: string
    path: string
    children?: MenuItem[]
  }
  ```

#### any 타입 금지
- [ ] 모든 변수/함수 반환값에 타입 명시
- [ ] `any` 타입 사용 금지
- [ ] React.FC 사용

### 🔟 반응형 검증

#### 모바일 (480px 이하)
- [ ] Sidebar 숨김 (햄버거 메뉴)
- [ ] AppBar 콤팩트 모드
- [ ] 콘텐츠 풀 너비

#### 태블릿 (768px)
- [ ] Sidebar 축소 (아이콘만)
- [ ] 2-3컬럼 레이아웃

#### 데스크톱 (1024px+)
- [ ] Sidebar 전체 표시
- [ ] 4컬럼+ 레이아웃

### 1️⃣1️⃣ 컴포넌트 재사용 검증

#### 공통 컴포넌트 사용
- [ ] MainLayout으로 모든 페이지 래핑
- [ ] Sidebar 메뉴 일관성
- [ ] AppBar 통일
- [ ] Breadcrumbs 경로 표시

#### MUI 스타일링
- [ ] 모든 UI 요소에 MUI 컴포넌트 및 sx prop 사용
- [ ] Tailwind CSS 사용 **없음** (패키지 미설치, className에 Tailwind 클래스 없음)
- [ ] 커스텀 CSS 최소화 (MUI 컴포넌트로 처리 가능한 것은 MUI 사용)

### 1️⃣2️⃣ JWT 토큰 보안 검증

#### URL 파라미터에 토큰 노출 금지
- [ ] FE 소스코드에서 URL 파라미터에 `token=` 이 포함된 문자열이 **없음**
  ```typescript
  ✗ `${BASE_URL}/api/file/content?...&token=${token}`
  ✗ `${url}?token=${getAccessToken()}`
  ✗ fetch(`/api/xxx?token=${token}`)
  ```
- [ ] `getAccessToken()` 결과가 URL 문자열 조합에 사용되지 않음 (헤더 설정에만 사용)
  ```typescript
  ✓ headers['Authorization'] = `Bearer ${token}`;
  ✗ const url = `...?token=${token}`;
  ```
- [ ] GET 요청의 Query Parameter에 JWT 토큰이 포함되지 않음
- [ ] POST 요청의 Request Body에 JWT 토큰이 포함되지 않음 (refresh 요청의 refreshToken 제외)
- [ ] `<img src>`, `<a href>` 등 HTML 속성 URL에 토큰이 포함되지 않음

#### BE SecurityConfig — 파일 콘텐츠/다운로드 permitAll 검증
- [ ] `/api/file/content` 가 SecurityConfig에서 `permitAll()` 처리됨
- [ ] `/api/file/download` 가 SecurityConfig에서 `permitAll()` 처리됨
- [ ] `/api/file/upload` 는 `authenticated()` (permitAll **아님**)
- [ ] `/api/file/delete` 는 `authenticated()` (permitAll **아님**)

### 1️⃣3️⃣ 사용자 홈 화면 (`/`) Mockup UI 검증

> 목업 파일: `docs/ui/mockup/mockup-01-select.html`을 기준으로 검증한다.

#### 헤더 영역
- [ ] 상단 sticky 헤더 존재 (스크롤 시 고정)
- [ ] 배경: 흰색, 하단 border (`#e0e0e0`)
- [ ] "AI 대화방" 제목 (fontSize 20px, fontWeight 700)
- [ ] "대화할 AI를 선택해주세요" 부제 (fontSize 13px, 회색)
- [ ] 중앙 정렬

#### 카드 그리드 영역
- [ ] 섹션 타이틀: 녹색 점(●) + "현재 대화 가능한 AI" 텍스트
- [ ] 카드 그리드: 데스크톱 3열, 모바일 2열 반응형
- [ ] 최대 너비 720px, 중앙 정렬

#### 개별 카드
- [ ] 흰색 배경, borderRadius 16px
- [ ] 아바타: 80x80 원형, `avatarColor` 배경, `avatarEmoji` 중앙 표시 (fontSize 36px+)
- [ ] 이름: fontSize 16px, fontWeight 600
- [ ] 설명: fontSize 12px, 회색(#999)
- [ ] 카테고리 태그(Chip): 하단에 표시
- [ ] hover 시: border `#4a90d9`, 그림자 증가, 살짝 위로 이동 (translateY)
- [ ] 클릭 시: `/chat/[id]`로 이동

#### 상태 처리
- [ ] 로딩 중: 스켈레톤 카드 표시 (4개)
- [ ] 데이터 0건: "등록된 AI 캐릭터가 없습니다." 메시지 중앙 표시
- [ ] 하단 안내: "관리자가 등록한 AI 캐릭터만 표시됩니다" (fontSize 12px, 회색)

#### 데이터 연동
- [ ] `GET /api/ai-prompt-contents/list` API 호출
- [ ] 응답의 `avatarEmoji`, `avatarColor`, `title`, `intro`, `categoryCode` 필드 사용
- [ ] `aiPromptContentsSeq`로 채팅 페이지 라우팅

#### 공통코드 캐싱 적용 (★ 필수)
- [ ] `useCommonCodes('ai_category')` 훅 사용
- [ ] 카테고리 태그에 `getCodeName('ai_category', ai.categoryCode)` 사용하여 **코드명**(예: "철학", "법률") 표시
- [ ] `categoryCode` 원시값(예: "law", "philosophy")이 화면에 그대로 노출되지 않음
- [ ] 공통코드 관리 페이지(`/admin/system/codes`)를 **제외한** 모든 페이지에서 동일 규칙 적용

### 1️⃣4️⃣ 채팅 화면 (`/chat/[id]`) Mockup UI 검증

> 목업 파일: `docs/ui/mockup/mockup-02-chat.html`을 기준으로 검증한다.

#### 헤더
- [ ] 뒤로가기 버튼 (`/`으로 이동)
- [ ] AI 아바타 + AI 이름 표시

#### 채팅 영역
- [ ] 배경색: `#abc1d1` (카카오톡 스타일)
- [ ] AI 메시지: 좌측 정렬, 흰색(`#ffffff`) 말풍선
- [ ] 사용자 메시지: 우측 정렬, 노란색(`#fef01b`) 말풍선
- [ ] 말풍선 borderRadius: 16px (꼬리 쪽 4px)
- [ ] 타이핑 인디케이터: 점 3개 애니메이션

#### 입력 영역
- [ ] 하단 고정 입력바
- [ ] 텍스트 입력 + 전송 버튼
- [ ] Enter 키로 전송 가능

---

## 📋 PART 2: Build & Environment 검증

### 1️⃣ Gradle 빌드 설정 검증

#### build.gradle
- [ ] `build.gradle` 파일 존재
- [ ] Java 버전 명시
  ```gradle
  ✓ java {
        toolchain {
            languageVersion = JavaLanguageVersion.of(21)
        }
    }
  ```
- [ ] 필수 의존성:
  - [ ] Spring Boot 3.3.4+
  - [ ] MyBatis 3.0.3+
  - [ ] PostgreSQL Driver
  - [ ] JWT (jjwt 0.12.6+)
  - [ ] Lombok
  - [ ] Spring Security
  - [ ] Spring Web

#### 빌드 검증
- [ ] `./gradlew clean build` 성공 (컴파일 에러 0개)
- [ ] 빌드 산출물 생성됨: `build/libs/*.jar`

### 2️⃣ Python 의존성 설치 검증 (LLM API)

#### requirements.txt 버전 호환성
- [ ] `requirements.txt` 파일 존재
- [ ] 버전 고정(`==`)이 현재 Python 버전의 사전 빌드 wheel을 지원하는지 확인
  ```bash
  # 현재 Python 버전 확인
  py --version  # 또는 python --version / python3 --version
  ```
- [ ] 최신 Python(3.13+)에서 Rust 소스 빌드가 필요한 패키지(pydantic-core 등)는 `>=` 최소 버전으로 지정
  ```
  ✓ pydantic>=2.11          # 최신 wheel이 설치되어 소스 빌드 불필요
  ✗ pydantic==2.10.3        # Python 3.14용 wheel이 없어 Rust 빌드 실패
  ```
- [ ] 핵심 패키지가 모두 포함됨: fastapi, uvicorn, openai, anthropic, google-genai, httpx, python-dotenv, pydantic

#### pip install 실행 검증
- [ ] `py -m pip install -r requirements.txt` 성공 (에러 0개)
  ```bash
  cd projs/llm-api
  py -m pip install -r requirements.txt
  ```
- [ ] Rust 컴파일 에러 없음 (`error: linking with link.exe failed` 등)
- [ ] `Failed building wheel` 에러 없음
- [ ] 설치 실패 시: 해당 패키지의 버전 고정을 `>=` 최소 버전으로 변경 후 재시도

#### Python 파일 컴파일 검증
- [ ] 모든 `.py` 파일 문법 검증 통과
  ```bash
  py -m py_compile main.py
  py -m py_compile app/config.py
  py -m py_compile app/routers/chat.py
  py -m py_compile app/services/llm_service.py
  py -m py_compile app/services/openai_service.py
  py -m py_compile app/services/anthropic_service.py
  py -m py_compile app/services/google_service.py
  py -m py_compile app/clients/backend_client.py
  py -m py_compile app/models/schemas.py
  ```

### 3️⃣ BE 런타임 엔드포인트 검증

> BE 서버를 실행하여 핵심 엔드포인트가 정상 동작하는지 확인한다.
> 검증 완료 후 **반드시 실행했던 Java 프로세스를 종료**한다.

#### /hello (Public 헬스체크)
- [ ] `curl http://localhost:9001/hello` → HTTP 200 응답
- [ ] 응답 body에 현재 시간 포함 (`ApiResponse.success(...)` 형식)
- [ ] Spring Security permitAll 정상 통과 (인증 없이 접근)

#### /api/auth/login (로그인)
- [ ] `curl -X POST http://localhost:9001/api/auth/login -H "Content-Type: application/json" -d '{"id":"admin","pw":"admin1234"}'` → HTTP 200 응답
- [ ] 응답 body에 `accessToken`, `refreshToken`, `usersSeq`, `name` 포함
- [ ] 잘못된 비밀번호 시 에러 응답 (200이 아닌 응답 또는 에러 메시지)
- [ ] DB의 `admin` 사용자 `pw` 컬럼에 Spring BCryptPasswordEncoder가 생성한 해시값 저장 확인
  - 평문: `admin1234`
  - BCrypt 해시: `$2a$10$jB4h7H2bGIxB5ejjPe0ZGe5NiYfrzQw1Axve0Rnwg0xVQHzwE.bKy`
  - **주의**: bcryptjs(Node) 등 외부 라이브러리가 생성한 `$2b$` 해시를 `$2a$`로 단순 치환하면 Spring과 호환되지 않을 수 있음. 반드시 Spring BCryptPasswordEncoder로 생성한 해시를 사용할 것

#### 실패 시 점검 사항
- [ ] `@MapperScan` 범위가 `*.mapper`로 한정되어 있는지 확인 (너무 넓으면 Service가 MyBatis 매퍼로 등록됨)
- [ ] SecurityConfig에 `/error` permitAll 포함 여부 확인 (누락 시 500이 403으로 변환)
- [ ] DB에 `admin` 사용자 레코드가 존재하고 `is_deleted = 'N'`인지 확인
- [ ] `admin` 사용자의 `pw` 컬럼이 평문이 아닌 BCrypt 해시값인지 확인 (`$2a$10$`으로 시작)

---

## 📋 PART 3: Admin BE 검증

### 1️⃣ MyBatis 검증

#### SQL 포맷팅
- [ ] `SELECT *` 사용 안 함
  ```sql
  ✓ SELECT u.users_seq, u.id, u.pw, ...
  ✗ SELECT * FROM users
  ```

- [ ] 모든 컬럼명 명시
  ```sql
  ✓ u.users_seq, u.id, u.created_at
  ✗ SELECT *, created_at
  ```

- [ ] Alias 일관성 (다 쓰거나 안 쓰거나)
  ```sql
  ✓ SELECT u.col1, u.col2 FROM users u
  ✓ SELECT col1, col2 FROM users
  ✗ SELECT u.col1, col2 FROM users u  (혼합 금지)
  ```

- [ ] 개행과 들여쓰기
  ```sql
  ✓ SELECT  u.col1
            ,u.col2
    FROM users u
    WHERE u.is_deleted = 'N'
    ORDER BY u.users_seq DESC
  
  ✗ SELECT u.col1, u.col2 FROM users u WHERE is_deleted = 'N'
  ```

#### selectAll 쿼리
- [ ] 정렬: `ORDER BY [pk_column] DESC`
  ```sql
  ✓ ORDER BY u.users_seq DESC
  ✗ ORDER BY created_at DESC
  ```

- [ ] 삭제된 데이터 제외
  ```sql
  ✓ WHERE u.is_deleted = 'N'
  ✗ (WHERE 절 없음)
  ```

#### selectById 쿼리
- [ ] PK로만 조회
  ```sql
  ✓ WHERE u.users_seq = #{usersSeq} AND u.is_deleted = 'N'
  ```

#### Mapper 인터페이스
- [ ] 메서드만 선언 (@Select/@Insert/@Update 어노테이션 없음)
  ```java
  ✓ List<UsersDTO> selectAll();
  ✗ @Select("SELECT ...") List<UsersDTO> selectAll();
  ```

- [ ] 메서드명: selectAll, selectById, insert, update, softDelete
  ```java
  ✓ void insert(UsersDTO usersDTO);
  ✓ void softDelete(UsersDTO usersDTO);
  ✗ void save(), void remove()
  ```

#### XML resultMap
- [ ] ResultMap 정의 (resultType="string" 금지)
- [ ] 모든 컬럼 매핑
- [ ] Property명은 camelCase

#### softDelete 쿼리
- [ ] UPDATE 문 사용 (DELETE 아님)
  ```xml
  ✓ <update id="softDelete">
        UPDATE users
        SET is_deleted = #{isDeleted}
            ,deleted_at = #{deletedAt}
            ,updated_by = #{updatedBy}
            ,updated_at = #{updatedAt}
        WHERE users_seq = #{usersSeq}
    </update>
  
  ✗ <delete id="delete"> ... </delete>
  ```

- [ ] 4개 컬럼 UPDATE: is_deleted, deleted_at, updated_by, updated_at
- [ ] update 쿼리와 별도 (공유 안 함)

### 2️⃣ Service 검증

#### 인터페이스/구현 분리
- [ ] Service는 interface로 정의
  ```java
  ✓ public interface UsersService { ... }
  ```

- [ ] ServiceImpl이 interface 구현
  ```java
  ✓ public class UsersServiceImpl implements UsersService { ... }
  ```

- [ ] @Service는 ServiceImpl에만 적용
  ```java
  ✓ @Service class UsersServiceImpl
  ✗ @Service interface UsersService
  ```

#### 메서드 시그니처 (Authentication 주입)
- [ ] Create: Authentication 파라미터
  ```java
  ✓ UsersDTO createUsers(UsersDTO usersDTO, Authentication authentication);
  ✗ UsersDTO createUsers(UsersDTO usersDTO, Long createdBy);
  ✗ UsersDTO createUsers(UsersDTO usersDTO);
  ```

- [ ] Update: Authentication 파라미터
  ```java
  ✓ UsersDTO updateUsers(Long usersSeq, UsersDTO usersDTO, Authentication authentication);
  ✗ UsersDTO updateUsers(Long usersSeq, UsersDTO usersDTO, Long updatedBy);
  ```

- [ ] Delete: Authentication 파라미터
  ```java
  ✓ void deleteUsers(Long usersSeq, Authentication authentication);
  ✗ void deleteUsers(Long usersSeq, Long deletedBy);
  ```

- [ ] ServiceImpl에 getCurrentUser 헬퍼 메서드 존재
  ```java
  ✓ private CustomUserDetails getCurrentUser(Authentication authentication) {
        return (CustomUserDetails) authentication.getPrincipal();
    }
  ```

#### Soft Delete 로직
- [ ] setIsDeleted('Y')
- [ ] setDeletedAt(LocalDateTime.now())
- [ ] setUpdatedBy(currentUser.getUsersSeq().intValue())  — Authentication에서 추출
- [ ] setUpdatedAt(LocalDateTime.now())
- [ ] `mapper.softDelete(user)` 호출 (update 아님)

### 3️⃣ Controller 검증

#### 의존성 주입 규칙
- [ ] Controller에서 Mapper 직접 주입 금지
  ```java
  ✗ @Autowired private UsersMapper usersMapper;  (Controller에서 Mapper 직접 주입 금지)
  ✓ @Autowired private UsersService usersService; (Controller는 Service만 주입)
  ```
- [ ] Controller → Service만 주입
- [ ] ServiceImpl → Mapper만 주입

#### 로그인 사용자 정보 (Spring Security)
- [ ] `@RequestHeader("X-User-Id")` 사용 금지
  ```java
  ✗ @RequestHeader("X-User-Id") Long createdBy  (절대 사용 금지)
  ```

- [ ] Controller에서 Authentication 파라미터로 수신하여 Service에 전달
  ```java
  ✓ @PostMapping("/create")
    public ResponseEntity<ApiResponse<UsersDTO>> createUsers(
            @RequestBody UsersDTO usersDTO,
            Authentication authentication) {
        UsersDTO created = usersService.createUsers(usersDTO, authentication);
        return ResponseEntity.ok(ApiResponse.success(created));
    }
  ```

- [ ] Update에서 Authentication 전달
  ```java
  ✓ @PostMapping("/update/{usersSeq}")
    public ResponseEntity<ApiResponse<UsersDTO>> updateUsers(
            @PathVariable Long usersSeq,
            @RequestBody UsersDTO usersDTO,
            Authentication authentication) { ... }
  ```

- [ ] Delete에서 Authentication 전달
  ```java
  ✓ @PostMapping("/delete/{usersSeq}")
    public ResponseEntity<ApiResponse<Void>> deleteUsers(
            @PathVariable Long usersSeq,
            Authentication authentication) { ... }
  ```

#### Spring Security 필수 구성 요소
- [ ] `JwtAuthenticationFilter` 존재 (OncePerRequestFilter 상속)
- [ ] `CustomUserDetails` 존재 (UserDetails 구현, usersSeq/id/name 필드)
- [ ] `JwtTokenProvider` 존재 (토큰 생성/검증/파싱)
- [ ] SecurityContextHolder에 Authentication 세팅 확인

#### RESTful API (GET, POST only)
> 공통 기능: `/api/{feature-name}/...`, 관리자 기능: `/api/admin/{feature-name}/...`
- [ ] GET /api/{feature-name}/page (목록 - 페이징)
- [ ] GET /api/{feature-name}/{id} (상세)
- [ ] POST /api/{feature-name}/create (생성)
- [ ] POST /api/{feature-name}/update/{id} (수정)
- [ ] POST /api/{feature-name}/delete/{id} (삭제)

#### API 명세 일치 검증 (`docs/api/api-admin-spec.md`)
- [ ] 구현된 엔드포인트 URL이 `api-admin-spec.md`에 정의된 URL과 정확히 일치
- [ ] HTTP Method(GET/POST)가 명세와 일치
- [ ] 요청 파라미터(Query Parameter, Request Body)가 명세와 일치
- [ ] 응답 형식(`ApiResponse<T>`)이 명세와 일치
- [ ] 페이징 엔드포인트는 URL에 `/page` 포함 여부 확인
- [ ] 첨부파일 엔드포인트가 명세의 섹션 9와 일치 (content, download, upload, list, delete)

### 4️⃣ 패키지 구조 검증

#### 패키지 명명
- [ ] 기능별 분리: `com.harness.beadmin.{featureName}` (공통) 또는 `com.harness.beadmin.admin.{featureName}` (관리자)
  ```
  ✓ com.harness.beadmin.users
  ✓ com.harness.beadmin.commonCodes
  ✓ com.harness.beadmin.admin.menus
  ✓ com.harness.beadmin.admin.roles
  ✗ com.harness.beadmin.controller
  ```

- [ ] 복수형 사용 (테이블명과 일치)
  ```
  ✓ users, commonCodes, orderItems
  ✗ user, commonCode, orderItem
  ```

#### 파일 위치
- [ ] Controller: `{feature}/controller/{FeatureName}Controller.java`
- [ ] Service Interface: `{feature}/service/{FeatureName}Service.java`
- [ ] Service Impl: `{feature}/service/impl/{FeatureName}ServiceImpl.java`
- [ ] Mapper: `{feature}/mapper/{FeatureName}Mapper.java`
- [ ] DTO: `{feature}/dto/{FeatureName}DTO.java`

### 5️⃣ DTO 검증

#### 클래스 명명
- [ ] 복수형: `UsersDTO`, `CommonCodesDTO`
- [ ] 필드명: camelCase

#### 필드 포함
- [ ] PK: `Long usersSeq`
- [ ] 비즈니스 필드: 테이블 정의와 일치
- [ ] 공통 필드:
  ```java
  private Character isDeleted;
  private LocalDateTime deletedAt;
  private Integer createdBy;
  private LocalDateTime createdAt;
  private Integer updatedBy;
  private LocalDateTime updatedAt;
  ```

#### 어노테이션
- [ ] @Data (Lombok)
- [ ] @NoArgsConstructor
- [ ] @AllArgsConstructor

---

## 📋 PART 3: 첨부파일 (File) 보안 검증

### 1️⃣ 파라미터 보안 검증

#### 콘텐츠/다운로드 파라미터 — 마스터/디테일 번호만 허용
- [ ] `/api/file/content` 파라미터가 `attachmentsSeq` + `attachmentFilesSeq`만 사용
  ```
  ✓ GET /api/file/content?attachmentsSeq=5&attachmentFilesSeq=1
  ✗ GET /api/file/content?fileName=test.png
  ✗ GET /api/file/content?filePath=/uploads/2026/test.png
  ✗ GET /api/file/content?attachmentFilesSeq=1 (마스터 번호 누락 금지)
  ```

- [ ] `/api/file/download` 파라미터가 `attachmentsSeq` + `attachmentFilesSeq`만 사용
  ```
  ✓ GET /api/file/download?attachmentsSeq=5&attachmentFilesSeq=1
  ✗ GET /api/file/download?originalName=test.png
  ✗ GET /api/file/download?storedName=uuid-xxx.png
  ✗ GET /api/file/download?path=/uploads/test.png
  ```

- [ ] `/api/file/delete` 파라미터가 `attachmentsSeq` + `attachmentFilesSeq`만 사용
  ```
  ✓ POST /api/file/delete?attachmentsSeq=5&attachmentFilesSeq=1
  ✗ POST /api/file/delete?filePath=/uploads/test.png
  ```

- [ ] 파일명(originalName, storedName)이 요청 파라미터에 **절대** 포함되지 않음
- [ ] 파일 경로(filePath)가 요청 파라미터에 **절대** 포함되지 않음
- [ ] MIME 타입이 요청 파라미터에 포함되지 않음

### 2️⃣ 404 응답 검증

- [ ] `attachments` 레코드 `is_deleted = 'Y'` → HTTP 404
- [ ] `attachment_files` 레코드 `is_deleted = 'Y'` → HTTP 404
- [ ] `attachments` 레코드 없음 → HTTP 404
- [ ] `attachment_files` 레코드 없음 → HTTP 404
- [ ] 파일 시스템에 파일 없음 (File Not Found) → HTTP 404
- [ ] Master-Detail 관계 불일치 (다른 마스터의 디테일 번호) → HTTP 404

### 3️⃣ 전략 패턴 검증

- [ ] `FileContentStrategy` 인터페이스 존재
  ```java
  ✓ boolean supports(String fileExt);
  ✓ ResponseEntity<Resource> serve(AttachmentFilesDTO file);
  ```

- [ ] `ImageContentStrategy` — png, jpg, jpeg, gif, svg 지원
  ```
  ✓ Content-Type: image/png, image/jpeg, image/svg+xml 등
  ✓ inline 표시 (Content-Disposition 없음 또는 inline)
  ```

- [ ] `PdfContentStrategy` — pdf 지원
  ```
  ✓ Content-Type: application/pdf
  ✓ Content-Disposition: inline
  ```

- [ ] `DefaultContentStrategy` — 기타 확장자 fallback
  ```
  ✓ Content-Type: application/octet-stream
  ✓ Content-Disposition: attachment
  ```

- [ ] 전략 선택 순서: ImageContent → PdfContent → Default (Default는 항상 최후순위)

### 4️⃣ 패키지 구조 검증

- [ ] `file/controller/FileController.java` 존재
- [ ] `file/service/FileService.java` (interface) 존재
- [ ] `file/service/impl/FileServiceImpl.java` 존재
- [ ] `file/mapper/FileMapper.java` 존재
- [ ] `file/dto/AttachmentsDTO.java` 존재
- [ ] `file/dto/AttachmentFilesDTO.java` 존재
- [ ] `file/strategy/` 디렉토리에 전략 클래스 존재

### 5️⃣ FE 첨부파일 사용 검증

- [ ] 이미지 표시 시 `<img src>` 에 마스터/디테일 번호만 사용
  ```html
  ✓ <img src="/api/file/content?attachmentsSeq=5&attachmentFilesSeq=1" onerror="onError(this)" />
  ✗ <img src="/api/file/content?fileName=test.png" />
  ✗ <img src="/uploads/2026/test.png" /> (직접 경로 접근 금지)
  ```

- [ ] 다운로드 링크에 마스터/디테일 번호만 사용
  ```html
  ✓ <a href="/api/file/download?attachmentsSeq=5&attachmentFilesSeq=1">다운로드</a>
  ✗ <a href="/api/file/download?filePath=/uploads/test.pdf">다운로드</a>
  ```

- [ ] onerror 핸들러로 404 이미지 대체 처리

### 6️⃣ 엔티티-첨부파일 연동 구조 검증

> 다른 Feature의 DTO에서 첨부파일(회원 프로필 이미지 등)을 포함하여 응답할 때의 구현 패턴을 검증한다. (AI 프롬프트는 이모지+색상 방식이므로 해당 없음)

#### DTO — 내부 클래스로 첨부파일 정보 포함
- [ ] 첨부파일이 필요한 DTO에 `ProfileImage` 등 내부 static 클래스가 정의됨
  ```java
  ✓ public class UsersDTO {
        private ProfileImage profileImage;

        @Getter @Setter @NoArgsConstructor
        public static class ProfileImage {
            private Long attachmentsSeq;
            private Long attachmentFilesSeq;
        }
    }
  ```
- [ ] 내부 클래스 필드는 `attachmentsSeq` + `attachmentFilesSeq` 두 개만 포함 (파일명, 경로 등 포함 금지)

#### MyBatis resultMap — association 매핑
- [ ] `resultMap`에 `<association>` 으로 내부 클래스 매핑
- [ ] `notNullColumn` 속성으로 첨부파일이 없을 때 `null` 반환 (빈 객체 생성 방지)
  ```xml
  ✓ <association property="profileImage"
               javaType="com.harness.beadmin.users.dto.UsersDTO$ProfileImage"
               notNullColumn="pi_attachments_seq">
        <result property="attachmentsSeq" column="pi_attachments_seq"/>
        <result property="attachmentFilesSeq" column="pi_attachment_files_seq"/>
    </association>
  ✗ notNullColumn 누락 → 첨부파일 없는 레코드에서 빈 객체({attachmentsSeq:null}) 반환
  ```

#### SQL — LEFT JOIN LATERAL로 최신 첨부파일 1건 조회
- [ ] `selectAll`, `selectById` 모두 첨부파일 JOIN이 포함됨 (목록·상세 모두 이미지 표시)
- [ ] `LEFT JOIN LATERAL` + `LIMIT 1`로 최신 파일 1건만 조회
- [ ] `attachments.is_deleted = 'N'` AND `attachment_files.is_deleted = 'N'` 조건 포함
- [ ] `target_table` + `target_seq` 조건으로 해당 엔티티의 첨부파일만 조회
  ```sql
  ✓ LEFT JOIN LATERAL (
        SELECT a.attachments_seq, af.attachment_files_seq
        FROM attachments a
        INNER JOIN attachment_files af
            ON a.attachments_seq = af.attachments_seq
            AND af.is_deleted = 'N'
        WHERE a.target_table = 'users'
          AND a.target_seq = u.users_seq
          AND a.is_deleted = 'N'
        ORDER BY af.attachment_files_seq DESC
        LIMIT 1
    ) pi ON true

  ✗ INNER JOIN (첨부파일 없는 레코드가 목록에서 누락됨)
  ✗ LEFT JOIN 없음 (API 응답에 profileImage가 항상 null)
  ✗ LIMIT 없음 (첨부파일이 여러 건일 때 행 중복)
  ```

---

## 📋 PART 4: 사용자 홈페이지 (AI 대화방) 목업 검증

> 목업 파일과 구현된 페이지를 비교하여 레이아웃, 색상, 동작이 일치하는지 검증한다.
> 목업 참조: `docs/ui/mockup/mockup-01-select.html`, `docs/ui/mockup/mockup-02-chat.html`

### 1️⃣ 라우팅 검증

- [ ] `/` 접근 시 AI 선택 화면 표시 (로그인 불필요)
- [ ] `/chat/[name]` 접근 시 채팅 화면 표시 (로그인 불필요)
- [ ] `[name]`은 영문 slug 사용 (예: `little-prince`, `wooyoungwoo`)
- [ ] AI 선택 카드 클릭 → `/chat/[name]`으로 정상 이동
- [ ] 채팅 화면 뒤로가기 → `/`로 정상 이동
- [ ] middleware PUBLIC_PATHS에 `/`, `/chat` 경로 포함

### 2️⃣ AI 선택 화면 (`/`) — mockup-01 대조

#### 헤더
- [ ] 타이틀 "AI 대화방" 표시
- [ ] 설명 문구 "대화할 AI를 선택해주세요" 표시

#### 카드 그리드
- [ ] 카드 레이아웃: `grid`, `minmax(200px, 1fr)`, `gap: 16px`
- [ ] 카드 배경: `#fff`, border-radius: `16px`
- [ ] 카드 hover 시: `border-color: #4a90d9`, 그림자 확대, `translateY(-2px)`
- [ ] 아바타: 원형, `avatarEmoji` 중앙 표시 + `avatarColor` 배경 (DB 필드 기반)
- [ ] 카드 내용: AI 이름(`title`) + 설명(`intro`) + 카테고리 태그(`categoryName`)
- [ ] 모바일(480px 이하): 2열 그리드로 전환

#### 데이터
- [ ] AI 목록이 BE API에서 동적 조회됨 (하드코딩 아님)
- [ ] 관리자가 등록한 AI만 표시됨

### 3️⃣ 채팅 화면 (`/chat/[name]`) — mockup-02 대조

#### 전체 레이아웃
- [ ] 배경색: `#abc1d1` (카카오톡 스타일)
- [ ] 전체 높이: 100vh, flex column 구조 (헤더 + 채팅 + 입력)

#### 채팅 헤더
- [ ] 뒤로가기 버튼 (`←`) → `/`로 이동
- [ ] AI 아바타 (원형, `avatarEmoji` + `avatarColor` 배경)
- [ ] AI 이름 + "AI 대화" 라벨

#### 말풍선 스타일
- [ ] AI 메시지: 좌측 정렬, 아바타 + 이름 표시
- [ ] AI 말풍선: 배경 `#fff`, border-radius `16px`, 좌상단 `4px`
- [ ] 사용자 메시지: 우측 정렬, 아바타/이름 없음
- [ ] 사용자 말풍선: 배경 `#fef01b`, border-radius `16px`, 우상단 `4px`
- [ ] 시간 표시: 말풍선 옆 하단, `10px`, 색상 `#666`
- [ ] 날짜 구분선: 중앙 정렬, 둥근 배경

#### 타이핑 인디케이터
- [ ] AI 응답 대기 중 점 3개 애니메이션 표시
- [ ] 점 크기 `6px`, 색상 `#999`, 순차 바운스 애니메이션

#### 입력 영역
- [ ] 하단 고정, 배경 `#fff`
- [ ] 텍스트 입력 + 전송 버튼
- [ ] 전송 버튼: 원형, 배경 `#fef01b`, hover 시 `#fee500`

#### 반응형
- [ ] 모바일(480px 이하): 말풍선 max-width `90%`
- [ ] 데스크톱: 말풍선 max-width `85%`

---

## 📋 PART 5: AI 프롬프트 관리 검증

### 1️⃣ 관리자 페이지 — AI 프롬프트 목록 (`/admin/content/ai-prompts`)

#### 페이지 구조
- [ ] 페이지 유형: `LIST` (`docs/ui/page-menu-admin.md` 섹션 10 참조)
- [ ] MainLayout으로 래핑, breadcrumbs: 콘텐츠 > AI 프롬프트
- [ ] 검색 영역: 제목(title) 입력 + 카테고리(categoryCode) 드롭다운 + 검색 버튼
- [ ] 카테고리 드롭다운: `GET /api/common-codes/detail/page?codeGroup=ai_category` 로 동적 조회

#### 테이블 컬럼
- [ ] No (순번), 아바타, 제목, 소개(말줄임), 카테고리(code_name), 등록일
- [ ] 아바타: 32×32 원형, `avatarColor` 배경 + `avatarEmoji` 중앙 표시
- [ ] 행 클릭 → `/admin/content/ai-prompts/detail/{aiPromptContentsSeq}` 이동
- [ ] 등록 버튼 → `/admin/content/ai-prompts/detail/new` 이동

#### 페이징 리스트 UI 규칙 (`docs/ui/paging-list-ui-admin.md`)
- [ ] Total 건수 좌측, 등록 버튼 우측
- [ ] 기본 10건, 건수 변경 셀렉트박스
- [ ] 번호 페이징 (5개씩), 이전/다음 버튼

### 2️⃣ 관리자 페이지 — AI 프롬프트 상세 (`/admin/content/ai-prompts/detail/:id`)

#### 페이지 구조
- [ ] 페이지 유형: `DETAIL` (`docs/ui/page-menu-admin.md` 섹션 11 참조)
- [ ] 모드: 조회 / 생성(`/detail/new`) / 수정
- [ ] 아바타 미리보기: 폼 최상단 배치 (이모지 + 그라데이션 원형)

#### 아바타 입력 (이모지 + 색상)
- [ ] 조회 모드: 아바타 미리보기만 표시 (입력 필드 읽기전용)
- [ ] 생성/수정 모드: `avatarEmoji` 입력 + `avatarColor` 입력 → 실시간 미리보기 갱신
- [ ] 이미지 업로드 방식이 아닌 텍스트 입력 방식 확인

#### 폼 필드
- [ ] 제목(`title`): 생성=입력, 수정=입력, 조회=읽기전용
- [ ] 카테고리(`categoryCode`): 생성/수정=드롭다운(캐싱된 코드), 조회=읽기전용(`getCodeName()` 변환)
- [ ] 소개(`intro`): 생성=입력, 수정=입력, 조회=읽기전용
- [ ] 프롬프트 내용(`promptContent`): 생성/수정=textarea, 조회=읽기전용
  - [ ] textarea 최소 10줄 높이
  - [ ] 모노스페이스 폰트 적용

#### 버튼
- [ ] 조회 모드: 수정, 삭제, 목록
- [ ] 생성 모드: 저장, 취소
- [ ] 수정 모드: 저장, 취소

### 3️⃣ 홈페이지(`/`) ↔ AI 프롬프트 데이터 매칭

> 홈페이지 목업(`mockup-01-select.html`)의 AI 선택 카드가 DB의 `ai_prompt_contents` 데이터와 정확히 매칭되는지 검증

#### 데이터 소스 매칭
- [ ] AI 카드 목록이 `GET /api/ai-prompt-contents/list` (Public) 에서 동적 조회됨
- [ ] 하드코딩된 AI 캐릭터 데이터가 **없음** (모두 DB에서 조회)
- [ ] `is_deleted = 'N'`인 레코드만 표시됨

#### 카드 ↔ 테이블 필드 매칭
| 카드 UI 요소 | DB 필드 | 비고 |
|-------------|---------|------|
| AI 이름 | `title` | |
| 설명 | `intro` | |
| 카테고리 태그 | `categoryCode` → FE 캐싱 `getCodeName()` 변환 표시 | |
| 아바타 이모지 | `avatarEmoji` | 원형 중앙 표시 |
| 아바타 배경 | `avatarColor` | CSS gradient 배경 |
| 카드 클릭 URL | `/chat/{aiPromptContentsSeq}` | PK 기반 slug |

#### 아바타 렌더링
- [ ] 아바타: `avatarColor`를 `background` 스타일로, `avatarEmoji`를 원형 중앙에 표시
- [ ] 첨부파일 API를 사용하지 않음 (이미지 업로드 방식 아님)

### 4️⃣ 채팅 화면(`/chat/[id]`) ↔ LLM API 스트리밍 매칭

#### 라우팅
- [ ] `/chat/[id]`의 `id`는 `aiPromptContentsSeq` (PK 숫자)
- [ ] 잘못된 id 접근 시 에러 처리 또는 `/`로 리다이렉트

#### 스트리밍 연동
- [ ] FE에서 LLM API(`http://localhost:9000`)로 **직접** 스트리밍 요청
- [ ] BE(Spring Boot)를 거치지 않고 직접 통신
- [ ] `NEXT_PUBLIC_LLM_API_URL` 환경변수 사용
- [ ] 스트리밍 엔드포인트: `POST /api/chat/stream`
- [ ] 요청 시 `aiPromptContentsSeq` (페르소나 ID) 전달
- [ ] 응답: `StreamingResponse` (chunked text/plain)
- [ ] FE에서 `fetch` + `ReadableStream`으로 토큰 단위 실시간 출력

#### 채팅 UI ↔ 스트리밍 동작
- [ ] AI 응답 수신 중 타이핑 인디케이터(점 3개) 표시
- [ ] 토큰 수신할 때마다 말풍선에 텍스트 추가 (실시간)
- [ ] 스트리밍 완료 후 타이핑 인디케이터 제거, 시간 표시
- [ ] 사용자 메시지 전송 후 입력 필드 초기화

### 5️⃣ LLM API 서버 검증

#### 프로젝트 구조
- [ ] `projs/llm-api/` 디렉토리 존재
- [ ] `main.py` — FastAPI 앱 엔트리포인트
- [ ] `requirements.txt` — 필수 패키지 포함 (fastapi, uvicorn, openai, anthropic, google-genai, httpx, python-dotenv)
- [ ] `.env.example` — API 키 템플릿 존재

#### 의존성 설치 검증
- [ ] `py -m pip install -r requirements.txt` 성공 — **PART 2 > 2️⃣ Python 의존성 설치 검증** 참조
- [ ] 모든 `.py` 파일 `py -m py_compile` 통과

#### API 키 검증
- [ ] `.env`에 API 키 미설정 시 안내 메시지 출력 후 서버 종료
- [ ] 최소 1개 이상 API 키 설정 시 정상 기동
- [ ] 설정된 프로바이더만 사용 가능 (미설정 프로바이더 요청 시 에러 응답)

#### CORS 설정
- [ ] FE 포트(예: 3000)에서의 요청 허용
- [ ] `allow_credentials=True`
- [ ] `allow_methods=["*"]`, `allow_headers=["*"]`

#### 페르소나 조회
- [ ] LLM API가 BE API(`GET /api/ai-prompt-contents/{id}`)를 호출하여 system prompt 조회
- [ ] DB에 직접 연결하지 않음

---

## 📋 PART 6: 공통코드 FE 캐싱 검증

> 공통코드 관리 페이지(`/admin/system/codes`)를 **제외한** 모든 페이지에서 공통코드 캐싱 방식을 사용하는지 검증한다.
> 규칙 참조: `docs/ui/common-code-cache.md`

### 1️⃣ `useCommonCodes` 훅 존재 검증

- [ ] 파일: `app/hooks/useCommonCodes.ts` 존재
- [ ] `GET /api/common-codes/cache/{codeGroup}` 호출
- [ ] 반환 타입: `{ codes, getCodeName, loading }`
- [ ] `codes`: `Record<string, CodeItem[]>` (codeGroup → 코드 리스트 맵)
- [ ] `getCodeName(codeGroup, codeValue)`: 코드명 반환 함수
- [ ] 여러 codeGroup을 한 번에 조회 가능 (`useCommonCodes('ai_category', 'status')`)

### 2️⃣ BE API 응답에 코드명 미포함 검증

- [ ] AI 프롬프트 API 응답에 `categoryName` 필드 **없음**
- [ ] `categoryCode` (코드값)만 반환
- [ ] BE SQL에서 `common_codes` JOIN **없음** (AI 프롬프트 관련 쿼리)
  ```
  ✗ LEFT JOIN common_codes cc ON cc.code_value = apc.category_code
  ✗ "categoryName": "철학"
  ✓ "categoryCode": "philosophy"  (코드값만 반환)
  ```

### 3️⃣ 리스트 페이지 캐싱 사용 검증

> AI 프롬프트 목록 등 공통코드를 사용하는 리스트 페이지 검증

#### 검색 Select
- [ ] 검색 드롭다운이 `codes[codeGroup]`으로 구성됨 (API 개별 호출 아님)
- [ ] `codeValue`를 option value로, `codeName`을 option label로 사용
- [ ] 전체(All) 옵션 포함

#### 테이블 컬럼
- [ ] 코드값 컬럼에 `getCodeName()` 사용하여 코드명 표시
- [ ] BE 응답의 코드명 필드(`categoryName` 등)에 의존하지 않음
  ```typescript
  ✓ getCodeName('ai_category', row.categoryCode)  // → "철학"
  ✗ row.categoryName  // BE에서 반환하지 않음
  ```

### 4️⃣ 상세/등록/수정 페이지 캐싱 사용 검증

- [ ] 폼 Select가 `codes[codeGroup]`으로 구성됨
- [ ] 생성/수정 모드: Select 드롭다운으로 선택, 선택된 `codeValue` 저장
- [ ] 조회 모드: `getCodeName()`으로 읽기전용 텍스트 표시
- [ ] `GET /api/common-codes/detail/page` 등 다른 API 호출로 드롭다운 구성하지 않음

### 5️⃣ BE 캐싱 API 엔드포인트 검증

- [ ] `GET /api/common-codes/cache/{codeGroup}` 엔드포인트 존재
- [ ] SecurityConfig에서 `permitAll` 처리됨 (인증 불필요)
- [ ] 그룹코드 자신 제외 (`code_group = code_value`인 행 제외)
- [ ] `is_deleted = 'N'` 조건 포함
- [ ] `order_seq` 오름차순 정렬
- [ ] 페이징 없이 전체 반환
- [ ] 응답 형식: `ApiResponse<List<CodeItem>>` (`codeValue`, `codeName` 필드만 포함)

### 6️⃣ 예외 확인

- [ ] 공통코드 관리 페이지(`/admin/system/codes`)는 캐싱 방식 **미적용** (기존 CRUD API 사용)
- [ ] 공통코드 관리 페이지에서 `useCommonCodes` 훅을 사용하지 않음

### 7️⃣ Master-Detail / 연관 조회 시 PK(코드값) 사용 검증

> 좌측 목록에서 행 선택 후 우측 상세/하위 목록을 조회할 때, **표시명(codeName 등)이 아닌 PK 또는 코드값(codeValue, seq 등)**으로 API를 호출해야 한다.
> 표시명으로 조회하면 DB 칼럼과 불일치하여 데이터가 조회되지 않는다.

- [ ] 공통코드 관리: 좌측 그룹코드 선택 시 세부코드 조회 API에 `codeValue`(= `code_group` 값, 예: `ai_category`)를 전달하는지 확인
  - ✗ `selectedGroup.codeName` (예: "AI 카테고리") → DB `code_group` 칼럼과 불일치, 데이터 0건
  - ✓ `selectedGroup.codeValue` (예: "ai_category") → DB `code_group` 칼럼과 일치
- [ ] 권한별 메뉴 관리: 좌측 권한 선택 시 `adminRolesSeq`(PK)로 매핑 조회하는지 확인
- [ ] 모든 Master-Detail 유형 페이지에서 연관 조회 파라미터가 PK 또는 코드값인지 확인 (표시명 사용 금지)

---

## 📋 PART 7: API 명세 vs 실제 구현 일치 검증 (★ 최우선)

> **이 검증을 반드시 수행한다.** API 명세(`docs/api/api-admin-spec.md`)에 정의된 모든 엔드포인트가 실제 코드에 구현되어 있는지, SecurityConfig permitAll 설정이 명세와 일치하는지 대조한다.
> 이전에 명세만 있고 구현이 빠진 엔드포인트(`/api/providers`), permitAll 누락(`/api/ai-prompt-contents/**`) 등의 사고가 반복되었다.

### 1️⃣ 엔드포인트 존재 검증 (명세 → 코드)

> `docs/api/api-admin-spec.md`의 전체 엔드포인트 요약표를 기준으로, 각 엔드포인트가 실제 코드에 존재하는지 1:1 대조한다.

#### BE (Spring Boot) 엔드포인트
- [ ] 명세의 **모든** BE 엔드포인트에 대해 해당 Controller 파일에 `@GetMapping`, `@PostMapping` 등 매핑이 존재하는지 grep으로 확인
  ```bash
  # 예시: 명세에 GET /api/users/page 가 있으면
  grep -rn "/users/page" projs/be-springboot/src/
  ```
- [ ] 매핑이 없는 엔드포인트 → **즉시 구현**
- [ ] URL 경로가 명세와 정확히 일치하는지 확인 (오타, 슬래시 누락 등)
- [ ] `@RequestMapping` 경로 + `@GetMapping`/`@PostMapping` 경로 조합이 명세의 전체 URL과 일치하는지 확인
  - 예: 명세가 `/api/admin/ai-prompt-contents/page`이면 `@RequestMapping("/api/admin/ai-prompt-contents")` + `@GetMapping("/page")`이어야 함
  - `@RequestMapping("/api/ai-prompt-contents")`로 되어 있으면 `/api/admin/` 접두사가 누락된 것 → 404 발생
- [ ] 관리자 CRUD API는 `/api/admin/` 접두사 필수, Public API는 `/api/` 접두사 사용 — 명세의 관리자/사용자 구분과 일치하는지 확인

#### LLM API (FastAPI) 엔드포인트
- [ ] 명세의 **모든** LLM API 엔드포인트에 대해 `@router.get`, `@router.post` 등 매핑이 존재하는지 확인
  ```bash
  grep -rn "api/providers\|api/chat/stream" projs/llm-api/app/
  ```
- [ ] 매핑이 없는 엔드포인트 → **즉시 구현**

#### FE → API 호출 경로 검증
- [ ] FE 코드에서 fetch/호출하는 API URL이 BE/LLM API에 실제 존재하는지 확인
  ```bash
  grep -rn "fetch\|API_URL" projs/fe-next/src/ | grep -v node_modules
  ```

### 2️⃣ SecurityConfig permitAll 일치 검증

> 명세에서 "Public", "인증 불필요", "permitAll" 로 표기된 엔드포인트가 SecurityConfig에 **모두** 등록되어 있는지 대조한다.

- [ ] `docs/api/api-admin-spec.md`에서 "permitAll", "Public", "인증 불필요" 키워드로 검색하여 Public 엔드포인트 목록 도출
- [ ] SecurityConfig.java의 `requestMatchers(...).permitAll()` 목록과 1:1 대조
- [ ] **명세에 Public인데 SecurityConfig에 없는 항목** → 즉시 추가
- [ ] 현재 필수 permitAll 항목:
  ```java
  .requestMatchers("/hello").permitAll()
  .requestMatchers("/error").permitAll()
  .requestMatchers("/api/auth/**").permitAll()
  .requestMatchers("/api/common-codes/cache/**").permitAll()
  .requestMatchers("/api/ai-prompt-contents/**").permitAll()
  .requestMatchers("/api/file/content").permitAll()
  .requestMatchers("/api/file/download").permitAll()
  ```

### 3️⃣ FE ↔ API 필드명 컨벤션 검증

> FE(JavaScript)는 camelCase, BE(Java)/LLM API(Python)는 snake_case를 사용한다.
> 요청/응답 JSON의 필드명이 FE와 API 간에 일치하는지 반드시 검증한다.

- [ ] FE에서 API로 보내는 요청 body의 필드명이 API 스키마와 일치하는지 확인
- [ ] Python Pydantic 모델에서 FE camelCase 필드를 받으려면 `Field(alias="camelCase")` 설정 필수
  ```python
  ✓ persona_id: int = Field(alias="personaId")  # FE에서 personaId로 전송
  ✗ persona_id: int  # FE가 personaId로 보내면 422 에러
  ```
- [ ] Spring Boot DTO는 기본적으로 camelCase이므로 FE와 일치 (별도 설정 불필요)
- [ ] API 응답 JSON 필드명이 FE에서 사용하는 키와 일치하는지 확인
- [ ] **LLM API에서 BE API 응답을 파싱할 때 필드명이 BE DTO와 일치하는지 확인**
  ```python
  ✓ persona.get("promptContent")   # BE DTO 필드명과 일치
  ✗ persona.get("instructions")    # BE에 없는 필드 → 항상 빈 값
  ```

### 4️⃣ API 응답 형식 일치 검증

- [ ] 명세의 Response 예시와 실제 API 응답 JSON 구조가 일치하는지 확인
- [ ] 필드명(camelCase/snake_case), 타입, 중첩 구조 대조
- [ ] `ApiResponse` 래퍼 형식 일관성 (`{ "status": "success", "data": ... }`)

### 5️⃣ curl 실행 검증 (런타임)

> BE/LLM API 서버가 실행 중일 때, 명세의 Public 엔드포인트를 실제 curl로 호출하여 200 응답을 확인한다.

- [ ] `curl http://localhost:8080/hello` → 200
- [ ] `curl http://localhost:8080/api/common-codes/cache/ai_category` → 200
- [ ] `curl http://localhost:8080/api/ai-prompt-contents/list` → 200
- [ ] `curl http://localhost:8080/api/ai-prompt-contents/1` → 200 (또는 데이터 없으면 적절한 응답)
- [ ] `curl http://localhost:9000/health` → 200
- [ ] `curl http://localhost:9000/api/providers` → 200
- [ ] 403 응답이 나오면 → SecurityConfig permitAll 누락 의심, 2️⃣ 체크리스트 재확인

---

## 🔍  검증 실행

### FE 자동 검증
```bash
cd projs/fe-next
npm run type-check
npm run lint
npm run build
```

### FE 수동 검증
1. 개발 서버 실행: `npm run dev -- --port 3001`
2. 브라우저 확인: http://localhost:3001
3. 모바일 반응형 확인 (F12 개발자도구)
4. 모든 메뉴 클릭 테스트

### BE 검증
```bash
./validate-schema.sh docs/db/tables.md docs/db/create-tables.sql
./validate-code.sh src/main/java/com/harness/beadmin
```

---

## ✅ 검증 실패 시

- [ ] 자세한 오류 메시지 제공
- [ ] 파일명 및 라인 번호 명시
- [ ] 올바른 형식 예시 제공
- [ ] 수정 방법 안내

---

## 📊  산출물

검증 완료 후 결과를 `reports/qa.md`에 저장합니다.
