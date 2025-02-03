import 'package:flutter/material.dart';
import '../models/motivation_model.dart';
import '../models/todo_model.dart';
import '../models/user_model.dart';
import '../api_service.dart';

class UserProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile(
    username: '',
    email: '',
    avatar: 'assets/avatar/avatar1.jpg',
  );

  List<Motivation> _motivations = [];
  List<Todo> _todos = [];
  String? _errorMessage;
  final ApiService _apiService = ApiService();

  UserProfile get userProfile => _userProfile;
  List<Motivation> get motivations => _motivations;
  List<Todo> get todos => _todos;
  String? get errorMessage => _errorMessage;

  void updateProfile(String username, String email, String avatar) {
    _userProfile = UserProfile(username: username, email: email, avatar: avatar);
    notifyListeners();
  }

  Future<void> updateProfileRemote(String username, String email, String avatar) async {
    _errorMessage = null;
    try {
      final userProfile = await _apiService.updateProfile(username, email, avatar);
      if (userProfile != null) {
        _userProfile = userProfile;
      } else {
        _errorMessage = 'Failed to update profile';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void addMotivation(Motivation motivation) {
    _motivations.add(motivation);
    notifyListeners();
  }

  void updateMotivation(Motivation updatedMotivation) {
    final index = _motivations.indexWhere((motivation) => motivation.id == updatedMotivation.id);
    if (index != -1) {
      _motivations[index] = updatedMotivation;
      notifyListeners();
    }
  }

  void deleteMotivation(int id) {
    _motivations.removeWhere((motivation) => motivation.id == id);
    notifyListeners();
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void updateTodo(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  void deleteTodo(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _errorMessage = null;
    try {
      final userProfile = await _apiService.login(email, password);
      if (userProfile != null) {
        _userProfile = userProfile;
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    _errorMessage = null;
    try {
      final userProfile = await _apiService.register(username, email, password);
      if (userProfile != null) {
        _userProfile = userProfile;
      } else {
        _errorMessage = 'Email is already in use';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchMotivations() async {
    try {
      final motivations = await _apiService.getMotivations();
      _motivations = motivations;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> createMotivation(String content) async {
    try {
      final motivation = await _apiService.createMotivation(content);
      addMotivation(motivation);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMotivationRemote(int id, String content) async {
    try {
      await _apiService.updateMotivation(id, content);
      final updatedMotivation = _motivations.firstWhere((motivation) => motivation.id == id);
      updatedMotivation.content = content;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMotivationRemote(int id) async {
    try {
      await _apiService.deleteMotivation(id);
      deleteMotivation(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchTodos() async {
    try {
      final todos = await _apiService.getTodos();
      _todos = todos;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> createTodo(String title, String description) async {
    try {
      final todo = await _apiService.createTodo(title, description);
      addTodo(todo);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTodoRemote(int id, String title, String description) async {
    try {
      await _apiService.updateTodo(id, title, description);
      final updatedTodo = _todos.firstWhere((todo) => todo.id == id);
      updatedTodo.title = title;
      updatedTodo.description = description;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTodoRemote(int id) async {
    try {
      await _apiService.deleteTodo(id);
      deleteTodo(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
