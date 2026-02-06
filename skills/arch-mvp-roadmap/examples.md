# MVP & Roadmap Examples

Concrete examples of MVP scoping and roadmap planning.

## Example: API Service MVP

### Context

Building a document processing API that extracts structured data from PDFs.

### MoSCoW Analysis

| Priority | Feature | Rationale |
|----------|---------|-----------|
| **Must** | PDF upload endpoint | Core input mechanism |
| **Must** | Text extraction | Minimum useful output |
| **Must** | JSON response format | API contract |
| **Must** | Basic error handling | Production-ready |
| **Should** | Table extraction | High-value enhancement |
| **Should** | Rate limiting | Operational safety |
| **Could** | Image extraction | Nice to have |
| **Could** | Batch processing | Efficiency feature |
| **Won't** | OCR for scanned docs | Different technology stack |

### PROJECT_PLAN.md

```markdown
# Project Plan: Document Processing API

**Generated**: 2024-01-15

## MVP Definition

### Must Have
- POST /documents endpoint accepts PDF upload
- Extract text content from PDF pages
- Return JSON with page-by-page text
- Error responses for invalid files, size limits
- Health check endpoint

### Should Have (Phase 2)
- Table detection and extraction
- Rate limiting per API key
- Async processing for large files

### Could Have (Phase 3)
- Image extraction with metadata
- Batch upload endpoint
- Webhook notifications

### Won't Have (Future)
- OCR for scanned documents
- Real-time streaming results

## Implementation Roadmap

### Phase 1: MVP Foundation
**Timeline**: 2 weeks
**Success Criteria**:
- Process 10-page PDF in < 5 seconds
- 99% uptime over 1 week
- 3 beta customers onboarded

Deliverables:
- [ ] FastAPI application structure
- [ ] PDF upload and validation
- [ ] PyMuPDF text extraction
- [ ] JSON response formatting
- [ ] Error handling middleware
- [ ] Docker deployment

### Phase 2: Core Enhancement
**Timeline**: 2 weeks
**Prerequisites**: MVP deployed, beta feedback collected
**Success Criteria**:
- Table extraction accuracy > 90%
- Handle 100 requests/minute

Deliverables:
- [ ] Table detection algorithm
- [ ] Structured table output
- [ ] Redis-based rate limiting
- [ ] Async job queue for large files

### Phase 3: Production Hardening
**Timeline**: 2 weeks
**Prerequisites**: Phase 2 complete, 10+ active customers
**Success Criteria**:
- < 1% error rate
- Customer satisfaction survey > 4/5

Deliverables:
- [ ] Image extraction
- [ ] Batch processing endpoint
- [ ] Webhook integration
- [ ] Documentation site
```

---

## PROJECT_PLAN.md Template

```markdown
# Project Plan: [Project Name]

**Generated**: [YYYY-MM-DD]
**Based on**: [research-synthesis-filename.md]

## MVP Definition

### Must Have
- [Feature 1]: [One sentence description]
- [Feature 2]: [One sentence description]
- [Feature 3]: [One sentence description]

### Should Have (Phase 2)
- [Feature]: [Description]
- [Feature]: [Description]

### Could Have (Phase 3)
- [Feature]: [Description]

### Won't Have (This Version)
- [Feature]: [Why excluded]

## Implementation Roadmap

### Phase 1: MVP Foundation
**Timeline**: [X weeks]
**Success Criteria**:
- [Measurable outcome 1]
- [Measurable outcome 2]

Deliverables:
- [ ] [Deliverable 1]
- [ ] [Deliverable 2]
- [ ] [Deliverable 3]

### Phase 2: [Phase Name]
**Timeline**: [X weeks]
**Prerequisites**: [What must be done first]
**Success Criteria**:
- [Measurable outcome]

Deliverables:
- [ ] [Deliverable]

### Phase 3: [Phase Name]
**Timeline**: [X weeks]
**Prerequisites**: [What must be done first]
**Success Criteria**:
- [Measurable outcome]

Deliverables:
- [ ] [Deliverable]

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | [H/M/L] | [H/M/L] | [Action] |

## Dependencies

| Dependency | Owner | Status | Needed By |
|------------|-------|--------|-----------|
| [Dependency] | [Team/Person] | [Status] | [Phase] |
```
