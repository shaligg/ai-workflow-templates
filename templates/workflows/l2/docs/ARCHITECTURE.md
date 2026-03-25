# System Architecture

## Overview

This system follows a layered architecture.

Layers:

API Layer  
Service Layer  
Data Layer

## Directory Structure

Use the current repository layout as source of truth.

Do not force `src/` if your project uses other paths.

Example placeholders (replace with real paths in current repo):

<project_path>/api
<project_path>/services
<project_path>/models
<project_path>/repositories

## Tech Stack

Language: Python  
Framework: FastAPI  
Database: PostgreSQL  
Testing: pytest

## Principles

Keep business logic inside services.

API layer should only handle HTTP logic.
