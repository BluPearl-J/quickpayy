from django.urls import path

from .views import register, login, home, login_page

urlpatterns = [
    path("register/", register, name="register"),
    path("login-api/", login, name="login_api"), # Change the API path
    path("login/", login_page, name="login"),    # This handles the visual page
    path("", home, name="landing_card"),
]