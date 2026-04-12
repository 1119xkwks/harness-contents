# 공통코드 FE 캐싱 규칙

> 공통코드 관리 페이지(`/admin/system/codes`)를 **제외한** 모든 페이지에서 공통코드는 FE 캐싱 방식을 사용한다.

---

## 핵심 원칙

| 항목 | 기존 방식 (사용 금지) | 캐싱 방식 (필수) |
|------|---------------------|-----------------|
| 코드명 표시 | BE에서 JOIN하여 `categoryName` 등 반환 | FE에서 캐싱된 코드 리스트로 `codeValue` → `codeName` 변환 |
| 검색 Select | BE 조회 결과로 드롭다운 구성 | 캐싱된 코드 리스트로 드롭다운 구성 |
| 폼 Select | 개별 API 호출로 드롭다운 구성 | 캐싱된 코드 리스트로 드롭다운 구성 |
| BE API 응답 | `categoryCode` + `categoryName` (JOIN) | `categoryCode`만 반환 (JOIN 불필요) |

---

## 캐싱 전용 API

```
GET /api/common-codes/cache/{codeGroup}
```

| 항목 | 값 |
|------|-----|
| **인증** | 불필요 (Public) — SecurityConfig `permitAll` |
| **용도** | FE 공통코드 캐싱 전용 |
| **캐싱 단위** | `codeGroup` (그룹코드의 `code_value`) |

**Response** `ApiResponse<List<CodeItem>>`

```json
{
  "status": "success",
  "data": [
    { "codeValue": "philosophy", "codeName": "철학" },
    { "codeValue": "law", "codeName": "법률" },
    { "codeValue": "cooking", "codeName": "요리" },
    { "codeValue": "travel", "codeName": "여행" }
  ]
}
```

- 그룹코드 자신은 제외 (`code_group = code_value`인 행 제외)
- `is_deleted = 'N'`인 것만 반환
- `order_seq` 오름차순 정렬
- 페이징 없음 (전체 반환)

---

## FE 유틸리티

### `useCommonCodes` 커스텀 훅

> 파일 위치: `app/hooks/useCommonCodes.ts`

```typescript
interface CodeItem {
  codeValue: string;
  codeName: string;
}

function useCommonCodes(...codeGroups: string[]): {
  codes: Record<string, CodeItem[]>;
  getCodeName: (codeGroup: string, codeValue: string) => string;
  loading: boolean;
}
```

#### 동작

1. 컴포넌트 마운트 시 전달받은 `codeGroups` 각각에 대해 `GET /api/common-codes/cache/{codeGroup}` 호출
2. 응답을 `codes` 맵에 저장 (키: codeGroup, 값: CodeItem[])
3. `getCodeName(codeGroup, codeValue)` — 캐싱된 코드에서 `codeValue`에 해당하는 `codeName` 반환
4. 로딩 완료 시 `loading = false`

#### 사용 예시

```typescript
const { codes, getCodeName, loading } = useCommonCodes('ai_category');

// 검색 Select 옵션 구성
const categoryOptions = codes['ai_category'] || [];

// 테이블 컬럼에서 코드명 표시
const categoryName = getCodeName('ai_category', row.categoryCode);
// → "철학"

// 폼 Select 옵션 구성 (동일)
<Select>
  {categoryOptions.map(code => (
    <MenuItem key={code.codeValue} value={code.codeValue}>
      {code.codeName}
    </MenuItem>
  ))}
</Select>
```

---

## 페이지별 사용 패턴

### 1. 리스트 페이지 (검색 + 테이블)

```
페이지 로드
  ↓
useCommonCodes('ai_category') 호출 → 캐싱
  ↓
┌─────────────────────────────────────┐
│ 검색 영역                            │
│  제목: [______]                      │
│  카테고리: [전체 ▼]  ← 캐싱된 코드   │
│                        [검색]        │
├─────────────────────────────────────┤
│ 테이블                               │
│  No │ 제목   │ 카테고리 │ 등록일      │
│  1  │ 어린왕자│ 철학 ←── │ 2026-04-12 │
│     │        │ getCodeName() 변환    │
└─────────────────────────────────────┘
```

- **검색 Select**: `codes['ai_category']`로 드롭다운 옵션 구성
- **테이블 컬럼**: `getCodeName('ai_category', row.categoryCode)`로 코드명 표시
- BE API 응답의 `categoryCode`(코드값)만 사용, `categoryName` 필드 없음

### 2. 상세/등록/수정 페이지 (폼)

```
페이지 로드
  ↓
useCommonCodes('ai_category') 호출 → 캐싱
  ↓
┌─────────────────────────────────────┐
│ 폼                                   │
│  카테고리: [철학 ▼]  ← 캐싱된 코드   │
│           value=categoryCode          │
│           label=codeName              │
│                                       │
│  조회 모드: getCodeName()으로 텍스트 표시 │
└─────────────────────────────────────┘
```

- **생성/수정 모드**: `codes['ai_category']`로 Select 옵션 구성, 선택된 `codeValue`를 저장
- **조회 모드**: `getCodeName('ai_category', data.categoryCode)`로 읽기전용 텍스트 표시

### 3. 여러 그룹코드가 필요한 경우

```typescript
// 한 번의 훅 호출로 여러 그룹 동시 조회
const { codes, getCodeName } = useCommonCodes('ai_category', 'status', 'region');

// 각각 사용
const categories = codes['ai_category'] || [];
const statuses = codes['status'] || [];
```

---

## BE 영향

### 금지 사항

- AI 프롬프트 등 공통코드를 사용하는 Feature의 SQL에서 `common_codes` 테이블 JOIN 금지
- DTO에 `categoryName` 등 코드명 필드 포함 금지
- API 응답에 코드명 반환 금지

### BE가 반환하는 것

- `categoryCode` (코드값, `code_value`)만 반환
- FE가 캐싱된 코드로 코드명을 직접 변환

### 예외

- **공통코드 관리 페이지** (`/admin/system/codes`): CRUD 목적이므로 기존 `/api/common-codes/*` API 그대로 사용

---

## 적용 대상 페이지

| 페이지 | 사용하는 공통코드 그룹 | 용도 |
|--------|---------------------|------|
| AI 프롬프트 목록 | `ai_category` | 검색 Select + 테이블 카테고리명 |
| AI 프롬프트 상세 | `ai_category` | 폼 Select (카테고리) |
| (향후 추가 페이지) | 해당 그룹코드 | 동일 패턴 적용 |

---

## 마지막 수정

- **작성일**: 2026-04-12
