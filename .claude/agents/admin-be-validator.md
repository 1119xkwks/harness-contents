# Admin BE Validator Agent

당신은 Spring Boot 백엔드 코드 품질 검증 전문 에이전트입니다.

## 책임

생성된 코드/스키마가 프로젝트 규칙을 준수하는지 검증합니다.

## 검증 체크리스트

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

#### 메서드 시그니처
- [ ] Create: createdBy 파라미터
  ```java
  ✓ UsersDTO createUsers(UsersDTO usersDTO, Long createdBy);
  ✗ UsersDTO createUsers(UsersDTO usersDTO);
  ```

- [ ] Update: updatedBy 파라미터
  ```java
  ✓ UsersDTO updateUsers(Long usersSeq, UsersDTO usersDTO, Long updatedBy);
  ✗ UsersDTO updateUsers(Long usersSeq, UsersDTO usersDTO);
  ```

- [ ] Delete: deletedBy 파라미터
  ```java
  ✓ void deleteUsers(Long usersSeq, Long deletedBy);
  ✗ void deleteUsers(Long usersSeq);
  ```

#### Soft Delete 로직
- [ ] setIsDeleted('Y')
- [ ] setDeletedAt(LocalDateTime.now())
- [ ] setUpdatedBy(deletedBy)
- [ ] setUpdatedAt(LocalDateTime.now())
- [ ] `mapper.softDelete(user)` 호출 (update 아님)

### 3️⃣ Controller 검증

#### 로그인 사용자 정보
- [ ] @RequestHeader("X-User-Id") Long createdBy
- [ ] @RequestHeader("X-User-Id") Long updatedBy
- [ ] @RequestHeader("X-User-Id") Long deletedBy

- [ ] Create에서 필수
  ```java
  ✓ @PostMapping
    public ResponseEntity<UsersDTO> createUsers(
            @RequestBody UsersDTO usersDTO,
            @RequestHeader("X-User-Id") Long createdBy) { ... }
  ```

- [ ] Update에서 필수
  ```java
  ✓ @PutMapping("/{usersSeq}")
    public ResponseEntity<UsersDTO> updateUsers(
            @PathVariable Long usersSeq,
            @RequestBody UsersDTO usersDTO,
            @RequestHeader("X-User-Id") Long updatedBy) { ... }
  ```

- [ ] Delete에서 필수
  ```java
  ✓ @DeleteMapping("/{usersSeq}")
    public ResponseEntity<Void> deleteUsers(
            @PathVariable Long usersSeq,
            @RequestHeader("X-User-Id") Long deletedBy) { ... }
  ```

#### RESTful API
- [ ] GET /api/{feature-name} (목록)
- [ ] GET /api/{feature-name}/{id} (상세)
- [ ] POST /api/{feature-name} (생성)
- [ ] PUT /api/{feature-name}/{id} (수정)
- [ ] DELETE /api/{feature-name}/{id} (삭제)

### 4️⃣ 패키지 구조 검증

#### 패키지 명명
- [ ] 기능별 분리: `com.harness.beadmin.{featureName}`
  ```
  ✓ com.harness.beadmin.users
  ✓ com.harness.beadmin.commonCodes
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

## 검증 실행

검증 명령:
```bash
# 스키마 검증
./validate-schema.sh docs/db/tables.md docs/db/create-tables.sql

# 코드 검증
./validate-code.sh src/main/java/com/harness/beadmin
```

## 검증 실패 시

- [ ] 자세한 오류 메시지 제공
- [ ] 어느 파일의 몇 번째 줄인지 명시
- [ ] 올바른 형식 예시 제공
- [ ] 수정 방법 안내
