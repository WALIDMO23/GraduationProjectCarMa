import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:graduation_project/core/network/api_client.dart';

class ChatProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  HubConnection? _hubConnection;
  bool _isConnected = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;

  // ── Load message history from API ──────────────────────────────
  Future<void> loadMessages(int serviceRequestId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.dio.get('/chat/$serviceRequestId');
      if (response.statusCode == 200) {
        final resData = response.data;
        if (resData['success'] == true) {
          final list = resData['data'] as List<dynamic>;
          _messages = list.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? e.message ?? 'Failed to load messages';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Send message via API ───────────────────────────────────────
  Future<bool> sendMessage(int serviceRequestId, int senderId, String senderName, String messageText) async {
    try {
      final response = await _apiClient.dio.post('/chat', data: {
        'serviceRequestId': serviceRequestId,
        'senderId': senderId,
        'senderName': senderName,
        'messageText': messageText,
      });

      if (response.statusCode == 200) {
        final resData = response.data;
        if (resData['success'] == true) {
          // If connection is active, SignalR will deliver the message to the list.
          // In case of lag or delay, we check if it is already in our list.
          final chatMsg = Map<String, dynamic>.from(resData['data']);
          final exists = _messages.any((m) => m['id'] == chatMsg['id']);
          if (!exists) {
            _messages.add(chatMsg);
            notifyListeners();
          }
          return true;
        }
      }
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? e.message ?? 'Failed to send message';
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
    return false;
  }

  // ── SignalR: Connect and Join chat room ────────────────────────
  Future<void> connectToChat(int serviceRequestId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) return;

      // Extract host dynamically from ApiClient base url to be compatible
      const hubUrl = 'http://107.21.214.224:8080/hubs/notifications';

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
              skipNegotiation: false,
            ),
          )
          .withAutomaticReconnect()
          .build();

      _hubConnection!.onclose(({error}) {
        _isConnected = false;
        notifyListeners();
      });

      await _hubConnection!.start();
      _isConnected = true;

      // Join the specific order chat room
      await _hubConnection!.invoke('JoinChatRoom', args: ['order_chat_$serviceRequestId']);

      // Listen for incoming messages
      _hubConnection!.on('ReceiveChatMessage', (args) {
        if (args != null && args.isNotEmpty && args[0] != null) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          
          // Verify it belongs to this order
          if (data['serviceRequestId'] == serviceRequestId) {
            final exists = _messages.any((m) => m['id'] == data['id']);
            if (!exists) {
              _messages.add(data);
              notifyListeners();
            }
          }
        }
      });

      notifyListeners();
    } catch (e) {
      debugPrint("SignalR Chat Connection Error: $e");
    }
  }

  // ── SignalR: Leave and Disconnect ──────────────────────────────
  Future<void> disconnectFromChat(int serviceRequestId) async {
    try {
      if (_hubConnection != null && _isConnected) {
        await _hubConnection!.invoke('LeaveChatRoom', args: ['order_chat_$serviceRequestId']);
        await _hubConnection!.stop();
      }
    } catch (e) {
      debugPrint("SignalR Chat Disconnection Error: $e");
    } finally {
      _hubConnection = null;
      _isConnected = false;
      notifyListeners();
    }
  }
}
