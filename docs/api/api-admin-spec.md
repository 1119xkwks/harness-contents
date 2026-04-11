# Admin API 명세서

> **Base URL**: `/api`
> **HTTP Methods**: `GET`, `POST` only
> **인증**: JWT Token (Bearer)
> **응답 포맷**: `ResponseEntity<ApiResponse<T>>`

---

## 공통 사항

### 공통 응답 래퍼

```java
public class ApiResponse<T> {
    private String status;  // "success" | "fail"
    private T data;         // 응답 데이터
    private ErrorInfo error; // 에러 정보 (성공 시 null)
}

public class ErrorInfo {
    private int code;       // 에러 코드 (HTTP 상태 코드)
    private String message; // 에러 메시지
}
```

**성공 응답 예시**
```json
{
  "status": "success",
  "data": { ... },
  "error": null
}
```

**에러 응답 예시**
```json
{
  "status": "fail",
  "data": null,
  "error": {
    "code": 404,
    "message": "사용자를 찾을 수 없습니다."
  }
}
```

### 에러 코드 정의

| 코드 | 설명 |
|------|------|
| `400` | 잘못된 요청 (필수 파라미터 누락, 잘못된 값) |
| `401` | 인증 실패 (로그인 실패, 유효하지 않은 토큰) |
| `403` | 권한 없음 (접근 권한 부족) |
| `404` | 리소스를 찾을 수 없음 |
| `409` | 중복 데이터 (ID, 역할명, 코드 등) |
| `500` | 서버 내부 오류 |
```

### 페이징 요청 파라미터 (Spring Pageable)

| 파라미터 | 타입 | 기본값 | 설명 |
|---------|------|--------|------|
| page    | int  | 0      | 페이지 번호 (0부터 시작) |
| size    | int  | 10     | 페이지당 건수 |
| sort    | String | null | 정렬 (예: `createdAt,desc`) |

### 페이징 응답 (Spring Page)

> 페이징이 필요한 엔드포인트는 URL에 `/page`를 포함한다. (예: `/api/users/page`)

**응답 예시**
```json
{
  "status": "success",
  "data": {
    "content": [...],
    "page": 0,
    "size": 10,
    "totalElements": 25,
    "totalPages": 3,
    "first": true,
    "last": false
  },
  "error": null
}
```

### 공통 헤더

| 헤더 | 필수 | 설명 |
|------|------|------|
| Authorization | Y | `Bearer {JWT_TOKEN}` |

> 로그인 사용자 정보(usersSeq, id, name)는 JWT 토큰에 포함되어 있으며, 서버에서 SecurityContextHolder를 통해 추출합니다.

### Method 규칙

| 동작 | Method | 비고 |
|------|--------|------|
| 조회 (목록/상세) | GET | Query Parameter |
| 생성 / 수정 / 삭제 | POST | Request Body |

---

## 0. 헬스체크 (Public - 인증 불필요)

### 0-1. DB 연결 확인

```
GET /hello
```

> 인증 없이 접근 가능. DB 연결 상태 확인용.

**Response** `ApiResponse<String>`
```json
{
  "status": "success",
  "data": "2026-04-11 14:30:00",
  "error": null
}
```

---

## 1. 인증 (Auth)

### 1-1. 로그인

```
POST /api/auth/login
```

**Request Body**
```json
{
  "id": "admin",
  "pw": "admin1234"
}
```

**Response** `ApiResponse<LoginResponse>`
```json
{
  "status": "success",
  "data": {
    "accessToken": "eyJhbGciOi...",
    "refreshToken": "eyJhbGciOi...",
    "usersSeq": 1,
    "name": "관리자",
    "isAdmin": "Y"
  }
}
```

### 1-2. 토큰 갱신

```
POST /api/auth/refresh
```

**Request Body**
```json
{
  "refreshToken": "eyJhbGciOi..."
}
```

**Response** `ApiResponse<TokenResponse>`
```json
{
  "status": "success",
  "data": {
    "accessToken": "eyJhbGciOi...",
    "refreshToken": "eyJhbGciOi..."
  }
}
```

### 1-3. 로그아웃

```
POST /api/auth/logout
```

**Request Body**
```json
{
  "refreshToken": "eyJhbGciOi..."
}
```

**Response** `ApiResponse<Void>`
```json
{
  "status": "success",
  "data": null
}
```

---

## 2. 사용자 관리 (Users)

### 2-1. 목록 조회

```
GET /api/users/page?page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |
| name | String | N | 회원명 검색 |
| id | String | N | 회원 ID 검색 |

**Response** `ApiResponse<Page<UsersDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "usersSeq": 1,
        "id": "admin",
        "name": "관리자",
        "isAdmin": "Y",
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00",
        "updatedBy": null,
        "updatedAt": null
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 1,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 2-2. 상세 조회

```
GET /api/users/{usersSeq}
```

**Response** `ApiResponse<UsersDTO>`
```json
{
  "status": "success",
  "data": {
    "usersSeq": 1,
    "id": "admin",
    "name": "관리자",
    "isAdmin": "Y",
    "isDeleted": "N",
    "createdBy": 1,
    "createdAt": "2026-04-11T00:00:00",
    "updatedBy": null,
    "updatedAt": null
  }
}
```

### 2-3. 생성

```
POST /api/users/create
```


**Request Body**
```json
{
  "id": "user01",
  "pw": "password123",
  "name": "홍길동",
  "isAdmin": "N"
}
```

**Response** `ApiResponse<UsersDTO>`

### 2-4. 수정

```
POST /api/users/update/{usersSeq}
```


**Request Body**
```json
{
  "name": "홍길동(수정)",
  "isAdmin": "Y"
}
```

**Response** `ApiResponse<UsersDTO>`

### 2-5. 삭제 (Soft Delete)

```
POST /api/users/delete/{usersSeq}
```


**Response** `ApiResponse<Void>`

---

## 3. 공통코드 - 그룹코드 (Common Codes - Group)

### 3-1. 그룹코드 목록 조회

```
GET /api/common-codes/group/page?page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |
| codeName | String | N | 코드명 검색 |

**Response** `ApiResponse<Page<CommonCodesDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "commonCodesSeq": 1,
        "codeName": "STATUS",
        "codeValue": "상태코드",
        "isGroupYn": "Y",
        "orderSeq": 1,
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00",
        "updatedBy": null,
        "updatedAt": null
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 1,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 3-2. 그룹코드 상세 조회

```
GET /api/common-codes/group/{commonCodesSeq}
```

**Response** `ApiResponse<CommonCodesDTO>`

### 3-3. 그룹코드 생성

```
POST /api/common-codes/group/create
```


**Request Body**
```json
{
  "codeName": "STATUS",
  "codeValue": "상태코드",
  "orderSeq": 1
}
```

> `isGroupYn`은 서버에서 `"Y"`로 자동 설정

**Response** `ApiResponse<CommonCodesDTO>`

### 3-4. 그룹코드 수정

```
POST /api/common-codes/group/update/{commonCodesSeq}
```


**Request Body**
```json
{
  "codeName": "STATUS",
  "codeValue": "상태코드(수정)",
  "orderSeq": 2
}
```

**Response** `ApiResponse<CommonCodesDTO>`

### 3-5. 그룹코드 삭제 (Soft Delete)

```
POST /api/common-codes/group/delete/{commonCodesSeq}
```


> 하위 세부코드도 함께 Soft Delete 처리

**Response** `ApiResponse<Void>`

---

## 4. 공통코드 - 세부코드 (Common Codes - Detail)

### 4-1. 세부코드 목록 조회 (그룹코드별)

```
GET /api/common-codes/detail/page?groupCodeName={codeName}&page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| groupCodeName | String | Y | 그룹코드의 codeName |
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |

**Response** `ApiResponse<Page<CommonCodesDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "commonCodesSeq": 2,
        "codeName": "STATUS",
        "codeValue": "ACTIVE",
        "isGroupYn": "N",
        "orderSeq": 1,
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00",
        "updatedBy": null,
        "updatedAt": null
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 3,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 4-2. 세부코드 상세 조회

```
GET /api/common-codes/detail/{commonCodesSeq}
```

**Response** `ApiResponse<CommonCodesDTO>`

### 4-3. 세부코드 생성

```
POST /api/common-codes/detail/create
```


**Request Body**
```json
{
  "codeName": "STATUS",
  "codeValue": "ACTIVE",
  "orderSeq": 1
}
```

> `isGroupYn`은 서버에서 `"N"`으로 자동 설정

**Response** `ApiResponse<CommonCodesDTO>`

### 4-4. 세부코드 수정

```
POST /api/common-codes/detail/update/{commonCodesSeq}
```


**Request Body**
```json
{
  "codeValue": "INACTIVE",
  "orderSeq": 2
}
```

**Response** `ApiResponse<CommonCodesDTO>`

### 4-5. 세부코드 삭제 (Soft Delete)

```
POST /api/common-codes/detail/delete/{commonCodesSeq}
```


**Response** `ApiResponse<Void>`

---

## 5. 메뉴 관리 (Admin Menus)

### 5-1. 메뉴 트리 조회 (사이드바용)

```
GET /api/admin/menus/tree
```

> 로그인 사용자의 역할에 매핑된 메뉴만 반환 (1depth > 2depth 트리 구조)

**Response** `ApiResponse<List<MenuTreeDTO>>`
```json
{
  "status": "success",
  "data": [
    {
      "adminMenusSeq": 1,
      "menuName": "대시보드",
      "menuIcon": "mdi-view-dashboard",
      "menuDepth": 1,
      "orderSeq": 1,
      "children": [
        {
          "adminMenusSeq": 4,
          "parentSeq": 1,
          "menuName": "대시보드",
          "menuUrl": "/admin",
          "menuDepth": 2,
          "orderSeq": 1
        }
      ]
    }
  ]
}
```

### 5-2. 메뉴 목록 조회 (관리용)

```
GET /api/admin/menus/page?page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |
| menuName | String | N | 메뉴명 검색 |
| menuDepth | int | N | 메뉴 깊이 필터 (1 또는 2) |

**Response** `ApiResponse<Page<AdminMenusDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "adminMenusSeq": 1,
        "parentSeq": null,
        "menuName": "대시보드",
        "menuUrl": null,
        "menuIcon": "mdi-view-dashboard",
        "menuDepth": 1,
        "orderSeq": 1,
        "isActive": "Y",
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00",
        "updatedBy": null,
        "updatedAt": null
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 8,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 5-3. 메뉴 상세 조회

```
GET /api/admin/menus/{adminMenusSeq}
```

**Response** `ApiResponse<AdminMenusDTO>`

### 5-4. 메뉴 생성

```
POST /api/admin/menus/create
```


**Request Body**
```json
{
  "parentSeq": null,
  "menuName": "콘텐츠 관리",
  "menuUrl": null,
  "menuIcon": "mdi-file-document",
  "menuDepth": 1,
  "orderSeq": 4,
  "isActive": "Y"
}
```

**Response** `ApiResponse<AdminMenusDTO>`

### 5-5. 메뉴 수정

```
POST /api/admin/menus/update/{adminMenusSeq}
```


**Request Body**
```json
{
  "menuName": "콘텐츠 관리(수정)",
  "menuIcon": "mdi-file-edit",
  "orderSeq": 5,
  "isActive": "Y"
}
```

**Response** `ApiResponse<AdminMenusDTO>`

### 5-6. 메뉴 삭제 (Soft Delete)

```
POST /api/admin/menus/delete/{adminMenusSeq}
```


> 1depth 메뉴 삭제 시 하위 2depth 메뉴도 함께 Soft Delete

**Response** `ApiResponse<Void>`

---

## 6. 역할 관리 (Admin Roles)

### 6-1. 역할 목록 조회

```
GET /api/admin/roles/page?page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |
| roleName | String | N | 역할명 검색 |

**Response** `ApiResponse<Page<AdminRolesDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "adminRolesSeq": 1,
        "roleName": "system",
        "roleDescription": "전체 권한 (시스템 관리 포함)",
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00",
        "updatedBy": null,
        "updatedAt": null
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 2,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 6-2. 역할 상세 조회

```
GET /api/admin/roles/{adminRolesSeq}
```

**Response** `ApiResponse<AdminRolesDTO>`

### 6-3. 역할 생성

```
POST /api/admin/roles/create
```


**Request Body**
```json
{
  "roleName": "editor",
  "roleDescription": "콘텐츠 편집 권한"
}
```

**Response** `ApiResponse<AdminRolesDTO>`

### 6-4. 역할 수정

```
POST /api/admin/roles/update/{adminRolesSeq}
```


**Request Body**
```json
{
  "roleName": "editor",
  "roleDescription": "콘텐츠 편집 권한 (수정)"
}
```

**Response** `ApiResponse<AdminRolesDTO>`

### 6-5. 역할 삭제 (Soft Delete)

```
POST /api/admin/roles/delete/{adminRolesSeq}
```


> 연관된 역할-사용자, 역할-메뉴 매핑도 함께 Soft Delete

**Response** `ApiResponse<Void>`

---

## 7. 역할-사용자 매핑 (Admin Role Users)

### 7-1. 역할별 사용자 목록 조회

```
GET /api/admin/role-users/page?adminRolesSeq={adminRolesSeq}&page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| adminRolesSeq | Long | Y | 역할 식별자 |
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |

**Response** `ApiResponse<Page<AdminRoleUsersDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "adminRoleUsersSeq": 1,
        "adminRolesSeq": 1,
        "usersSeq": 1,
        "userName": "관리자",
        "userId": "admin",
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00"
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 1,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 7-2. 역할-사용자 매핑 생성

```
POST /api/admin/role-users/create
```


**Request Body**
```json
{
  "adminRolesSeq": 1,
  "usersSeq": 2
}
```

**Response** `ApiResponse<AdminRoleUsersDTO>`

### 7-3. 역할-사용자 매핑 삭제 (Soft Delete)

```
POST /api/admin/role-users/delete/{adminRoleUsersSeq}
```


**Response** `ApiResponse<Void>`

---

## 8. 역할-메뉴 매핑 (Admin Role Menus)

### 8-1. 역할별 메뉴 목록 조회

```
GET /api/admin/role-menus/page?adminRolesSeq={adminRolesSeq}&page=0&size=10
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| adminRolesSeq | Long | Y | 역할 식별자 |
| page | int | N | 페이지 번호 (기본 0) |
| size | int | N | 페이지당 건수 (기본 10) |
| sort | String | N | 정렬 (예: `createdAt,desc`) |

**Response** `ApiResponse<Page<AdminRoleMenusDTO>>`
```json
{
  "status": "success",
  "data": {
    "content": [
      {
        "adminRoleMenusSeq": 1,
        "adminRolesSeq": 1,
        "adminMenusSeq": 1,
        "menuName": "대시보드",
        "isDeleted": "N",
        "createdBy": 1,
        "createdAt": "2026-04-11T00:00:00"
      }
    ],
    "page": 0,
    "size": 10,
    "totalElements": 8,
    "totalPages": 1,
    "first": true,
    "last": true
  }
}
```

### 8-2. 역할-메뉴 매핑 일괄 저장

```
POST /api/admin/role-menus/save
```


> 기존 매핑을 Soft Delete 후 새로운 매핑을 일괄 생성 (체크박스 UI 대응)

**Request Body**
```json
{
  "adminRolesSeq": 1,
  "adminMenusSeqList": [1, 2, 3, 4, 5]
}
```

**Response** `ApiResponse<List<AdminRoleMenusDTO>>`

### 8-3. 역할-메뉴 매핑 삭제 (Soft Delete)

```
POST /api/admin/role-menus/delete/{adminRoleMenusSeq}
```


**Response** `ApiResponse<Void>`

---

## 9. 첨부파일 (File)

> 첨부파일 콘텐츠/다운로드 파라미터는 반드시 **마스터 번호(attachmentsSeq) + 디테일 번호(attachmentFilesSeq)**로만 전달한다.
> 파일명, 파일 경로, MIME 타입 등은 파라미터에 **절대 포함하지 않는다** (보안 규칙).
>
> **인증 규칙**:
> - `content`, `download` 엔드포인트는 **Public (인증 불필요)** — `<img src>` 등에서 토큰 없이 접근해야 하므로 SecurityConfig에서 permitAll 처리
> - `upload`, `delete` 엔드포인트는 **인증 필요** (Bearer 토큰)
> - **JWT 토큰을 URL 파라미터(Query String)에 절대 포함하지 않는다** — 토큰은 반드시 `Authorization` 헤더로만 전달

### 9-1. 파일 업로드

```
POST /api/file/upload (multipart/form-data)
```

**Request (multipart/form-data)**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| targetTable | String | Y | 첨부 대상 테이블명 (예: `users`, `boards`) |
| targetSeq | Long | Y | 첨부 대상 테이블의 PK 값 |
| files | MultipartFile[] | Y | 업로드할 파일 (복수 가능) |

**Response** `ApiResponse<AttachmentsDTO>`
```json
{
  "status": "success",
  "data": {
    "attachmentsSeq": 5,
    "targetTable": "boards",
    "targetSeq": 1,
    "isDeleted": "N",
    "createdBy": 1,
    "createdAt": "2026-04-11T14:30:00",
    "files": [
      {
        "attachmentFilesSeq": 1,
        "attachmentsSeq": 5,
        "originalName": "profile.png",
        "storedName": "a1b2c3d4-uuid.png",
        "filePath": "/uploads/2026/04",
        "fileSize": 204800,
        "fileExt": "png",
        "mimeType": "image/png",
        "orderSeq": 0
      },
      {
        "attachmentFilesSeq": 2,
        "attachmentsSeq": 5,
        "originalName": "document.pdf",
        "storedName": "e5f6g7h8-uuid.pdf",
        "filePath": "/uploads/2026/04",
        "fileSize": 1048576,
        "fileExt": "pdf",
        "mimeType": "application/pdf",
        "orderSeq": 1
      }
    ]
  }
}
```

### 9-2. 파일 콘텐츠 보기 (Public - 인증 불필요)

```
GET /api/file/content?attachmentsSeq={마스터번호}&attachmentFilesSeq={디테일번호}
```

> **인증 불필요** — `<img src>` 등에서 토큰 없이 직접 접근해야 하므로 permitAll 처리.
> 전략 패턴에 따라 파일 확장자별로 Content-Type이 결정된다.
> - **이미지** (png, jpg, jpeg, gif, svg): `image/*` — inline 표시
> - **PDF**: `application/pdf` — inline 표시
> - **기타**: `application/octet-stream` — 다운로드 fallback

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| attachmentsSeq | Long | Y | 첨부파일 마스터 번호 |
| attachmentFilesSeq | Long | Y | 첨부파일 디테일 번호 |

**Response**: 파일 바이너리 (Content-Type은 전략 패턴에 의해 결정)

**404 반환 조건**:
- `attachments` 레코드의 `is_deleted = 'Y'`
- `attachment_files` 레코드의 `is_deleted = 'Y'`
- `attachments` 또는 `attachment_files` 레코드가 존재하지 않음
- Master-Detail 관계 불일치 (다른 마스터의 디테일 번호)
- 파일 시스템에 파일이 존재하지 않음

**FE 사용 예시**:
```html
<img src="/api/file/content?attachmentsSeq=5&attachmentFilesSeq=1" onerror="onError(this)" />
```

### 9-3. 파일 다운로드 (Public - 인증 불필요)

```
GET /api/file/download?attachmentsSeq={마스터번호}&attachmentFilesSeq={디테일번호}
```

> **인증 불필요** — permitAll 처리.
> 확장자에 관계없이 항상 `Content-Disposition: attachment`로 강제 다운로드한다.

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| attachmentsSeq | Long | Y | 첨부파일 마스터 번호 |
| attachmentFilesSeq | Long | Y | 첨부파일 디테일 번호 |

**Response**: 파일 바이너리
```
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="원본파일명.확장자"
```

**404 반환 조건**: 콘텐츠 보기와 동일

### 9-4. 첨부파일 목록 조회 (마스터 기준)

```
GET /api/file/list?attachmentsSeq={마스터번호}
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| attachmentsSeq | Long | Y | 첨부파일 마스터 번호 |

**Response** `ApiResponse<List<AttachmentFilesDTO>>`
```json
{
  "status": "success",
  "data": [
    {
      "attachmentFilesSeq": 1,
      "attachmentsSeq": 5,
      "originalName": "profile.png",
      "fileSize": 204800,
      "fileExt": "png",
      "mimeType": "image/png",
      "orderSeq": 0,
      "createdAt": "2026-04-11T14:30:00"
    },
    {
      "attachmentFilesSeq": 2,
      "attachmentsSeq": 5,
      "originalName": "document.pdf",
      "fileSize": 1048576,
      "fileExt": "pdf",
      "mimeType": "application/pdf",
      "orderSeq": 1,
      "createdAt": "2026-04-11T14:30:00"
    }
  ]
}
```

### 9-5. 개별 파일 삭제 (Soft Delete)

```
POST /api/file/delete?attachmentsSeq={마스터번호}&attachmentFilesSeq={디테일번호}
```

**Query Parameters**

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|------|------|
| attachmentsSeq | Long | Y | 첨부파일 마스터 번호 |
| attachmentFilesSeq | Long | Y | 첨부파일 디테일 번호 |

**Response** `ApiResponse<Void>`
```json
{
  "status": "success",
  "data": null
}
```

---

## API 엔드포인트 요약

| # | Method | URL | 설명 |
|---|--------|-----|------|
| **Health (Public)** |
| 0 | GET | `/hello` | DB 연결 확인 (인증 불필요) |
| **Auth** |
| 1 | POST | `/api/auth/login` | 로그인 |
| 2 | POST | `/api/auth/refresh` | 토큰 갱신 |
| 3 | POST | `/api/auth/logout` | 로그아웃 |
| **Users** |
| 4 | GET | `/api/users/page` | 사용자 목록 |
| 5 | GET | `/api/users/{usersSeq}` | 사용자 상세 |
| 6 | POST | `/api/users/create` | 사용자 생성 |
| 7 | POST | `/api/users/update/{usersSeq}` | 사용자 수정 |
| 8 | POST | `/api/users/delete/{usersSeq}` | 사용자 삭제 |
| **Common Codes - Group** |
| 9 | GET | `/api/common-codes/group/page` | 그룹코드 목록 |
| 10 | GET | `/api/common-codes/group/{commonCodesSeq}` | 그룹코드 상세 |
| 11 | POST | `/api/common-codes/group/create` | 그룹코드 생성 |
| 12 | POST | `/api/common-codes/group/update/{commonCodesSeq}` | 그룹코드 수정 |
| 13 | POST | `/api/common-codes/group/delete/{commonCodesSeq}` | 그룹코드 삭제 |
| **Common Codes - Detail** |
| 14 | GET | `/api/common-codes/detail/page` | 세부코드 목록 |
| 15 | GET | `/api/common-codes/detail/{commonCodesSeq}` | 세부코드 상세 |
| 16 | POST | `/api/common-codes/detail/create` | 세부코드 생성 |
| 17 | POST | `/api/common-codes/detail/update/{commonCodesSeq}` | 세부코드 수정 |
| 18 | POST | `/api/common-codes/detail/delete/{commonCodesSeq}` | 세부코드 삭제 |
| **Admin Menus** |
| 19 | GET | `/api/admin/menus/tree` | 메뉴 트리 (사이드바) |
| 20 | GET | `/api/admin/menus/page` | 메뉴 목록 |
| 21 | GET | `/api/admin/menus/{adminMenusSeq}` | 메뉴 상세 |
| 22 | POST | `/api/admin/menus/create` | 메뉴 생성 |
| 23 | POST | `/api/admin/menus/update/{adminMenusSeq}` | 메뉴 수정 |
| 24 | POST | `/api/admin/menus/delete/{adminMenusSeq}` | 메뉴 삭제 |
| **Admin Roles** |
| 25 | GET | `/api/admin/roles/page` | 역할 목록 |
| 26 | GET | `/api/admin/roles/{adminRolesSeq}` | 역할 상세 |
| 27 | POST | `/api/admin/roles/create` | 역할 생성 |
| 28 | POST | `/api/admin/roles/update/{adminRolesSeq}` | 역할 수정 |
| 29 | POST | `/api/admin/roles/delete/{adminRolesSeq}` | 역할 삭제 |
| **Admin Role Users** |
| 30 | GET | `/api/admin/role-users/page` | 역할별 사용자 목록 |
| 31 | POST | `/api/admin/role-users/create` | 역할-사용자 매핑 |
| 32 | POST | `/api/admin/role-users/delete/{adminRoleUsersSeq}` | 역할-사용자 삭제 |
| **Admin Role Menus** |
| 33 | GET | `/api/admin/role-menus/page` | 역할별 메뉴 목록 |
| 34 | POST | `/api/admin/role-menus/save` | 역할-메뉴 일괄 저장 |
| 35 | POST | `/api/admin/role-menus/delete/{adminRoleMenusSeq}` | 역할-메뉴 삭제 |
| **File (첨부파일)** |
| 36 | POST | `/api/file/upload` | 파일 업로드 (multipart) |
| 37 | GET | `/api/file/content?attachmentsSeq=&attachmentFilesSeq=` | 파일 콘텐츠 보기 (Public, 전략 패턴) |
| 38 | GET | `/api/file/download?attachmentsSeq=&attachmentFilesSeq=` | 파일 다운로드 (Public, 강제) |
| 39 | GET | `/api/file/list?attachmentsSeq=` | 첨부파일 목록 (마스터 기준) |
| 40 | POST | `/api/file/delete?attachmentsSeq=&attachmentFilesSeq=` | 파일 삭제 (Soft Delete) |
