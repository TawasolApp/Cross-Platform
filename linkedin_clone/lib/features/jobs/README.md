# Tawasol App – Jobs Module

This module is part of **Tawasol**, a LinkedIn-clone application. The **Jobs Module** handles all job-related operations such as posting jobs, applying, managing applications, saving jobs, and job searching.

---

## 📦 Overview

This module enables users to:
- Post and manage job offers
- Apply for jobs
- View applicants for a job
- Save or unsave jobs
- Search for jobs using various filters

---

## 🧱 Architecture

The module follows **Clean Architecture** principles, split into:

### 1. Data Layer
Responsible for remote data operations and mapping models.

**Files:**
- `datasource/job_remote_data_source.dart` - Handles API calls for job-related data.
- `model/create_job_model.dart` - Model for creating a new job posting.
- `model/job_model.dart` - Model representing a job.
- `model/application_model.dart` - Model representing a job application.
- `repositories/job_repository_impl.dart` - Implementation of job repository for data handling.

---

### 2. Domain Layer
Defines business logic and use cases.

**Entities:**
- `job_entity.dart` - Entity representing a job.
- `application_entity.dart` - Entity representing a job application.
- `apply_for_job_entity.dart` - Entity for applying to a job.

**Repositories:**
- `job_repository.dart` - Abstract repository for job-related operations.

**Use Cases:**
- `apply_for_job_use_case.dart` - Handles job application logic.
- `create_job_posting_use_case.dart` - Handles job posting creation.
- `delete_job_use_case.dart` - Handles job deletion.
- `get_applicants_use_case.dart` - Retrieves applicants for a job.
- `get_job_by_id_use_case.dart` - Fetches job details by ID.
- `save_job_use_case.dart` - Saves a job for later.
- `search_jobs_use_case.dart` - Searches for jobs with filters.
- `unsave_job_use_case.dart` - Removes a saved job.
- `update_application_status_use_case.dart` - Updates the status of a job application.

---

### 3. Presentation Layer
Handles UI components and state management.

**Pages:**
- `job_applicant_cv_page.dart` - Displays applicant CV details.
- `job_applicants_page.dart` - Lists applicants for a job.
- `jobs_filter_page.dart` - UI for filtering job searches.
- `jobs_search_page.dart` - UI for searching jobs.

**Providers:**
- `job_applicants_provider.dart` - Manages state for job applicants.
- `job_apply_provider.dart` - Manages state for job applications.
- `job_details_provider.dart` - Manages state for job details.
- `job_search_provider.dart` - Manages state for job search.
- `saved_jobs_provider.dart` - Manages state for saved jobs.

**Widgets:**
- `job_applicant_card_widget.dart` - Displays applicant information in a card.
- `job_apply_widget.dart` - UI for applying to a job.
- `job_card.dart` - Displays job details in a card format.
- `job_details_screen.dart` - Detailed view of a job.

---

## 📁 Folder Structure

```
jobs/
├── data/
│   ├── datasource/
│   │   └── job_remote_data_source.dart - Handles API calls for job-related data.
│   ├── model/
│   │   ├── application_model.dart - Model representing a job application.
│   │   ├── create_job_model.dart - Model for creating a new job posting.
│   │   └── job_model.dart - Model representing a job.
│   └── repositories/
│       └── job_repository_impl.dart - Implementation of job repository for data handling.
│
├── domain/
│   ├── entities/
│   │   ├── application_entity.dart - Entity representing a job application.
│   │   ├── apply_for_job_entity.dart - Entity for applying to a job.
│   │   └── job_entity.dart - Entity representing a job.
│   ├── repositories/
│   │   └── job_repository.dart - Abstract repository for job-related operations.
│   └── usecases/
│       ├── apply_for_job_use_case.dart - Handles job application logic.
│       ├── create_job_posting_use_case.dart - Handles job posting creation.
│       ├── delete_job_use_case.dart - Handles job deletion.
│       ├── get_applicants_use_case.dart - Retrieves applicants for a job.
│       ├── get_job_by_id_use_case.dart - Fetches job details by ID.
│       ├── save_job_use_case.dart - Saves a job for later.
│       ├── search_jobs_use_case.dart - Searches for jobs with filters.
│       ├── unsave_job_use_case.dart - Removes a saved job.
│       └── update_application_status_use_case.dart - Updates the status of a job application.
│
├── presentation/
│   ├── pages/
│   │   ├── job_applicant_cv_page.dart - Displays applicant CV details.
│   │   ├── job_applicants_page.dart - Lists applicants for a job.
│   │   ├── jobs_filter_page.dart - UI for filtering job searches.
│   │   └── jobs_search_page.dart - UI for searching jobs.
│   ├── providers/
│   │   ├── job_applicants_provider.dart - Manages state for job applicants.
│   │   ├── job_apply_provider.dart - Manages state for job applications.
│   │   ├── job_details_provider.dart - Manages state for job details.
│   │   ├── job_search_provider.dart - Manages state for job search.
│   │   └── saved_jobs_provider.dart - Manages state for saved jobs.
│   └── widgets/
│       ├── job_applicant_card_widget.dart - Displays applicant information in a card.
│       ├── job_apply_widget.dart - UI for applying to a job.
│       ├── job_card.dart - Displays job details in a card format.
│       └── job_details_screen.dart - Detailed view of a job.
```

---

## ✅ Features

- Job Creation & Deletion
- Job Application Flow
- Applicant Management
- Job Saving/Unsaving
- Job Filtering & Search
- Modular UI Components with Provider State Management

---
