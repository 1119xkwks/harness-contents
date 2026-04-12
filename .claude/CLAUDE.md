# Claude Code 프로젝트 가이드

## Skills (슬래시 명령어)

### `/projs-setup`
관리자 FE, BE, LLM API를 자동으로 생성합니다.
- 레이아웃, 컴포넌트, 페이지 모두 자동 생성
- 프로젝트 생성 위치:
  - `projs/fe-next` — Next.js 프론트엔드
  - `projs/be-springboot` — Spring Boot 백엔드
  - `projs/llm-api` — Python FastAPI LLM 스트리밍 채팅 API

## 개발 서버 실행

### FE (Next.js)
```bash
cd projs/fe-next && npm run dev -- --port 3000
```
완료 후 http://localhost:3000에서 대시보드를 확인할 수 있습니다.

### LLM API (FastAPI)
```bash
cd projs/llm-api && uvicorn main:app --host 0.0.0.0 --port 9000 --reload
```
실행 전 `projs/llm-api/.env`에 최소 1개 LLM API 키를 설정해야 합니다.
