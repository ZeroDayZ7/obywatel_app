abstract class OutboxTransportClient {
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload);
}
