# Tawasol App - Company Module

> This module is part of **Tawasol**, a LinkedIn-clone application. The `company` module is responsible for managing all company-related operations including company creation, editing, job postings, admin management, and analytics.

## 📦 Overview
This module enables users to:
- Create and edit company profiles
- Manage company admins
- View and search companies
- Post jobs and view recent job posts
- Browse company followers and related companies

Built using **Flutter** with **Clean Architecture**, the module ensures separation of concerns and testability.

---

## 🏗 Architecture
The project adopts **Clean Architecture** with three main layers:

### 1. Data Layer
- Responsible for API interactions and data models.
- Contains:
  - **datasources/**: Remote data source classes that handle API communication.
    - `company_remote_data_source.dart`: Handles network operations for company data.
    - `job_remote_data_source.dart`: Sends/receives job-related API requests.
    - `media_remote_data_source.dart.dart`: Manages media/image-related remote operations.
    - `user_remote_data_source.dart`: Provides remote user data for company functions.
  - **models/**: Defines structures for API request/response data.
    - `add_admin_request_model.dart`: Model for admin addition request.
    - `company_create_model.dart`: Data model used for creating a company.
    - `company_edit_model.dart`: Model for updating company details.
    - `company_model.dart`: General company structure.
    - `create_job_model.dart`: Model for job posting creation.
    - `job_model.dart`: Model representing job post structure.
    - `user_model.dart`: Model for user information related to the company.
  - **repositories/**: Implementation of repository interfaces that connect data sources with domain logic.
    - `company_repository_impl.dart`: Implements company repository logic.
    - `job_repository_impl.dart`: Business logic for job-related data.
    - `user_repository_impl.dart`: Repository logic for handling user information.

### 2. Domain Layer
- Contains the core business logic and rules.
- Contains:
  - **entities/**:
    - `company.dart`: Base entity for a company.
    - `company_create_entity.dart`: Represents company creation data.
    - `company_update_entity.dart`: Represents company update information.
    - `create_job_entity.dart`: Represents job creation information.
    - `job.dart`: Core job entity.
    - `user.dart`: Core user entity.
  - **repositories/**:
    - `company_repository.dart`: Abstract methods for company features.
    - `job_repository.dart`: Abstract job operations.
    - `media_repository.dart`: Abstract interface for media handling.
    - `user_repository.dart`: Abstract interface for user-related operations.
  - **usecases/**:
    - `add_admin_use_case.dart`: Logic to add a new admin.
    - `create_company_usecase.dart`: Use case to create a company.
    - `create_job_posting_use_case.dart`: Handles creation of job postings.
    - `geta_all_company_admins.dart`: Fetches all company admins.
    - `get_all_companies.dart`: Gets a list of all companies.
    - `get_company_details_usecase.dart`: Fetches a single company's details.
    - `get_company_followers_use_case.dart`: Retrieves company followers.
    - `get_friends_following_company_usecase.dart`: Finds friends following a company.
    - `get_recent_job_use_case.dart`: Gets recently posted jobs.
    - `get_related_companies_usecase.dart`: Gets similar/related companies.
    - `search_users_use_case.dart`: Searches for users.
    - `update_company_details_use_case.dart`: Handles updating company data.
    - `upload_image_use_case.dart`: Logic for uploading images.

### 3. Presentation Layer
- Manages UI rendering and state logic.
- Contains:
  - **providers/**:
    - `company_provider.dart`: Handles fetching and storing company details
    - `company_admins_provider.dart`: Manages admin list and actions
    - `company_create_provider.dart`: Manages the company creation process
    - `company_edit_provider.dart`: Handles editing and updating company details
    - `company_list_companies_provider.dart`: Provides data for company listings
    - `related_companies_provider.dart`: Fetches and stores related companies data

  - **screens/**:
    - `companies_list_screen.dart`: Shows a list of all companies
    - `company_add_admins_screen.dart`: UI for adding admins to a company
    - `company_add_job_screen.dart`: UI for creating job postings
    - `company_create_screen.dart`: Screen for creating a new company
    - `company_edit_details_screen.dart`: Screen for editing existing company info
    - `company_job_analytics_screen.dart`: Displays job-related analytics
    - `company_profile_screen.dart`: Detailed view of a specific company profile

  - **widgets/**:
    - `company_about_tab_widget.dart`: Tab showing company about info
    - `company_home_tab_widget.dart`: Tab for company home info
    - `company_jobs_tab_widget.dart`: Tab showing job posts
    - `company_list_followers.dart`: List of company followers
    - `company_list_related_companies.dart`: Related company suggestions
    - `company_page_tabs.dart`: UI tabs for company sections
    - `company_posts_tab.dart`: Posts related to company
    - `job_apply_widget.dart`: Apply button and interaction for jobs
    - `job_card_widget.dart`: Visual card for displaying job info
    - `job_details.dart`: Full job description and metadata
    - `recent_jobs_widget.dart`: Displays list of recently posted jobs

---

## 📂 Folder Structure
```
company/
├── data/
│   ├── datasources/          # Remote API calls
│   ├── models/               # Request/response and domain-related data models
│   └── repositories/         # Data-layer repository implementations
│
├── domain/
│   ├── entities/             # Core data structures used in business logic
│   ├── repositories/         # Abstract contracts for repositories
│   └── usecases/             # Application-specific actions and rules
│
├── presentation/
│   ├── providers/            # State management classes
│   ├── screens/              # UI screens related to company features
│   └── widgets/              # Modular, reusable UI components
```

---

## 🚀 Features Implemented
- ✅ Company creation/editing UI and functionality
- ✅ Job posting with dynamic form model
- ✅ Company profile with tabs (About, Jobs, Posts, Followers)
- ✅ Provider-based state management
- ✅ Image upload and user search use cases
- ✅ Analytics widget for job performance

---

## 🛠 How to Use

### 1. Integration
In your main `pubspec.yaml`, include the module:
```yaml
dependencies:
  company:
    path: ./modules/company
```

### 2. Navigation
Use named routes or `Navigator.push` to access screens like:
```dart
Navigator.pushNamed(context, CompanyProfileScreen.routeName);
```

### 3. State Management
All screens rely on providers in `presentation/providers` for state handling.

---



---

Thank you for checking out the `company` module of Tawasol! 🎉

