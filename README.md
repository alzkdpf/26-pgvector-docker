# pgvector Docker for Coolify

PostgreSQL 16 + pgvector extension Docker 이미지입니다. Coolify 배포에 최적화되어 있습니다.

## 🚀 빠른 시작

### 1. 환경 변수 설정

```bash
cp .env.example .env
# .env 파일을 열어 비밀번호와 설정을 수정하세요
```

### 2. 컨테이너 실행

```bash
docker-compose up -d
```

## ⚙️ 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `POSTGRES_USER` | `postgres` | PostgreSQL 사용자 이름 |
| `POSTGRES_PASSWORD` | `changeme` | PostgreSQL 비밀번호 |
| `POSTGRES_DB` | `vectordb` | 기본 데이터베이스 이름 |
| `POSTGRES_PORT` | `5432` | 외부 포트 (호스트 포트) |

## 📁 디렉토리 구조

```
.
├── Dockerfile              # pgvector 이미지 빌드
├── docker-compose.yml      # 컨테이너 설정
├── .env.example            # 환경 변수 템플릿
├── init-scripts/           # DB 초기화 스크립트
│   └── 01-init-pgvector.sql
├── scripts/                # 유틸리티 스크립트
│   ├── backup.sh           # 백업 스크립트
│   └── restore.sh          # 복원 스크립트
└── backups/                # 백업 파일 저장 (자동 생성)
```

## 💾 백업 & 복원

### 백업 실행

```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```

백업 파일은 `./backups/` 디렉토리에 저장됩니다:
- `*.dump` - PostgreSQL custom format (추천)
- `*.sql.gz` - 압축된 SQL 덤프

### 복원 실행

```bash
chmod +x scripts/restore.sh
./scripts/restore.sh ./backups/vectordb_20240101_120000.dump
```

## 🔗 Coolify 배포

### Git 연동 배포

1. 이 저장소를 Coolify에 연결
2. **Build Pack**: Dockerfile 선택
3. **Environment Variables**에서 환경 변수 설정:
   - `POSTGRES_USER`
   - `POSTGRES_PASSWORD` (안전한 비밀번호 사용!)
   - `POSTGRES_DB`
   - `POSTGRES_PORT` (필요시)

### Storage 설정

Coolify의 **Storage** 탭에서:
- `/var/lib/postgresql/data` → Persistent Volume 마운트
- `/backups` → 백업용 볼륨 마운트 (선택사항)

## 📊 pgvector 사용 예시

```sql
-- Vector extension 확인
SELECT * FROM pg_extension WHERE extname = 'vector';

-- Vector 컬럼이 있는 테이블 생성
CREATE TABLE documents (
    id BIGSERIAL PRIMARY KEY,
    content TEXT,
    embedding vector(1536)  -- OpenAI embeddings
);

-- Vector 인덱스 생성 (IVFFlat)
CREATE INDEX ON documents 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- 유사도 검색
SELECT content, embedding <=> '[0.1, 0.2, ...]'::vector AS distance
FROM documents
ORDER BY distance
LIMIT 10;
```

## 🔧 연결 정보

```
Host: localhost (또는 Coolify 도메인)
Port: 5432 (또는 POSTGRES_PORT 값)
Database: vectordb (또는 POSTGRES_DB 값)
Username: postgres (또는 POSTGRES_USER 값)
Password: (POSTGRES_PASSWORD 값)
```

## 📝 라이선스

MIT License
