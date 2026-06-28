# Profile Feature

## 1. Description of the Features Implemented

The Profile feature implements a comprehensive user profile management system similar to LinkedIn. It allows users to:

- View and edit their profile information (name, headline, bio, location, industry)
- Manage profile and cover photos
- Add, update, and delete work experiences
- Add, update, and delete education history
- Add, update, and delete certifications
- Add, update, and delete skills
- View skill endorsements from other users
- Upload and manage resume
- Toggle visibility of different profile sections

The implementation follows Clean Architecture principles with a clear separation between presentation, domain, and data layers.

## 2. Overview of Folder and File Structure

The Profile feature follows a Clean Architecture approach with the following folder structure:

```
lib/features/profile/
├── data/                  # Data layer implementation
│   ├── datasources/       # Data sources (remote and local)
│   ├── models/            # Data models and mappers
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer with business logic
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Use cases for all profile operations
│       ├── certifications/
│       ├── education/
│       ├── experience/
│       ├── profile/
│       └── skills/
└── presentation/          # Presentation layer
    ├── pages/             # UI screens
    ├── provider/          # State management
    └── widgets/           # Reusable UI components
```

## 3. Description of Files and Features Implementation

### Domain Layer

#### Entities

- `profile.dart`: Core profile entity with user's basic information
- `experience.dart`: Entity for work experience entries
- `education.dart`: Entity for educational background
- `certification.dart`: Entity for professional certifications
- `skill.dart`: Entity for professional skills
- `endorsement.dart`: Entity for skill endorsements

#### Repositories

- `profile_repository.dart`: Interface for profile data operations

#### Use Cases

The use cases are grouped by feature:

**Profile**:
- `get_profile.dart`: Fetches user profile data
- `update_profile_picture.dart`: Updates profile picture
- `delete_profile_picture.dart`: Removes profile picture
- `update_cover_picture.dart`: Updates cover photo
- `delete_cover_photo.dart`: Removes cover photo
- `update_headline.dart`: Updates professional headline
- `delete_headline.dart`: Removes professional headline
- `update_industry.dart`: Updates industry information
- `delete_industry.dart`: Removes industry information
- `update_location.dart`: Updates location information
- `delete_location.dart`: Removes location information
- `update_first_name.dart`: Updates first name
- `update_last_name.dart`: Updates last name
- `update_resume.dart`: Updates resume document
- `delete_resume.dart`: Removes resume document
- `update_bio.dart`: Updates professional bio
- `delete_bio.dart`: Removes professional bio

**Experience**:
- `add_experience.dart`: Adds new work experience
- `update_experience.dart`: Updates existing work experience
- `delete_experience.dart`: Removes work experience

**Education**:
- `add_education.dart`: Adds new education entry
- `update_education.dart`: Updates existing education entry
- `delete_education.dart`: Removes education entry

**Certifications**:
- `add_certification.dart`: Adds new certification
- `update_certification.dart`: Updates existing certification
- `delete_certification.dart`: Removes certification

**Skills**:
- `add_skill.dart`: Adds new skill
- `update_skill.dart`: Updates existing skill
- `delete_skill.dart`: Removes skill
- `get_skill_endorsements.dart`: Fetches endorsements for a skill

### Data Layer

#### Data Sources

- `profile_remote_data_source.dart`: Handles API calls for profile data
- `profile_local_data_source.dart`: Manages cached profile data

#### Models

- `profile_model.dart`: Data transfer object for profile
- `experience_model.dart`: Data transfer object for experience
- `education_model.dart`: Data transfer object for education
- `certification_model.dart`: Data transfer object for certification
- `skill_model.dart`: Data transfer object for skill
- `endorsement_model.dart`: Data transfer object for endorsement

#### Repositories

- `profile_repository_impl.dart`: Implementation of the profile repository

### Presentation Layer

#### Provider

- `profile_provider.dart`: State management for profile feature using ChangeNotifier

#### Pages

- `profile_page.dart`: Main profile screen
- `edit_profile_page.dart`: Screen for editing basic profile info
- `experience_form_page.dart`: Form for adding/editing experiences
- `education_form_page.dart`: Form for adding/editing education
- `certification_form_page.dart`: Form for adding/editing certifications
- `skill_form_page.dart`: Form for adding/editing skills
- `view_endorsements_page.dart`: Screen to view skill endorsements

#### Widgets

- `profile_header_widget.dart`: Displays profile picture, cover photo, and name
- `profile_actions_widget.dart`: Shows action buttons (edit, connect, etc.)
- `experience_list_widget.dart`: Displays list of experiences
- `education_list_widget.dart`: Displays list of education entries
- `certification_list_widget.dart`: Displays list of certifications
- `skill_list_widget.dart`: Displays list of skills
- `bio_widget.dart`: Displays and manages the bio section
- `section_header_widget.dart`: Reusable section header with actions

## 4. User Experience Assumptions

1. **Progressive Disclosure**: The profile follows a progressive disclosure pattern, with expandable/collapsible sections for work experience, education, certifications, and skills to reduce information overload.

2. **Immediate Feedback**: When users make changes to their profile, the UI updates immediately to reflect these changes, even before server confirmation. If the server update fails, the UI is rolled back.

3. **Image Management**: Users can select images from their device gallery for profile and cover photos. The implementation assumes these images need to be processed (potentially resized/cropped) before uploading.

4. **Section Prioritization**: The implementation assumes that basic profile information (name, headline, photo) is the most important, followed by work experience, then education, then skills and certifications.

5. **Offline Capabilities**: The profile data is cached for offline viewing, with changes queued for when connectivity is restored.

6. **Privacy Control**: The implementation includes a visibility setting, assuming users want control over who can view different sections of their profile.

7. **Profile Viewing Modes**: The profile screen can be viewed in both "self" mode and "other user" mode, with different action options available in each mode.

8. **Resume Handling**: The implementation assumes users will upload PDF files as resumes, which can be viewed inline or downloaded.

9. **Endorsement Handling**: Skill endorsements are visible but actual endorsement functionality is handled elsewhere in the application.

10. **Connection Status**: The profile displays connection status information, assuming integration with a connection feature elsewhere in the app.
