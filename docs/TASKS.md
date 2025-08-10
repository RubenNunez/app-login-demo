# App Login Demo – Task Breakdown

This document lists all required tasks for the login form implementation.

## 📝 Requirements

- [ ] Create a login screen with:
  - [x] Email address input
  - [x] Password input
  - [x] Submit button / Sign In button

## ✅ Validation Rules

- [ ] Email must be in a valid format (e.g., `user@example.com`)
- [ ] Password must:
  - [ ] Be at least 12 characters long
  - [ ] Contain at least 1 uppercase letter
  - [ ] Contain at least 1 lowercase letter
  - [ ] Contain at least 1 digit
  - [ ] Contain at least 1 special character (`!@#$%^&*`, etc.)
- [ ] Show user-friendly error messages when input is invalid

## 🔄 Submit Flow

- [ ] When the form is valid:
  - [x] Simulate backend request with 3-second delay
  - [ ] Show loading indicator during the delay
  - [x] Navigate to a new screen when "response" arrives
  - [x] New screen can remain empty

## 🎨 UX & Feedback

- [ ] Provide clear visual feedback for invalid fields
- [ ] Disable submit button when inputs are invalid or request is pending

## 📦 Project Setup

- [x] Initialize Git repository
- [x] Push code to a **public GitHub repo**
- [x] Include a README with:
  - [x] Project description
  - [ ] Setup instructions
  - [ ] How to run the app

---