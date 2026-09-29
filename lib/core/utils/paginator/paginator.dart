// core/utils/paginator.dart

import 'package:get/get.dart';

import '../../network/base/dio_client.dart';

// core/utils/paginator.dart

class Paginator<T> {
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxString error = ''.obs;

  int _page = 1;
  final int limit;

  // ✅ Now returns both the items AND the meta, so hasNextPage is server-driven
  final Future<PaginatedResult<T>> Function(int page, int limit) fetchPage;

  Paginator({required this.fetchPage, this.limit = 10});

  int get currentPage => _page;

  Future<void> loadInitial() async {
    _page = 1;
    hasMore.value = true;
    items.clear();
    error.value = '';
    isLoading.value = true;

    try {
      final result = await fetchPage(_page, limit);
      items.assignAll(result.data);

      hasMore.value = result.meta?.hasNextPage ?? false; // ✅ server truth
      if (hasMore.value) _page++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    // ✅ guard — never hit the API again once hasMore is false
    if (isLoadingMore.value || isLoading.value || !hasMore.value) {
      print(
        '🛑 [Paginator] skipping loadMore — hasMore=${hasMore.value}, isLoadingMore=${isLoadingMore.value}',
      );
      return;
    }

    isLoadingMore.value = true;

    try {
      final result = await fetchPage(_page, limit);
      items.addAll(result.data);
      hasMore.value = result.meta?.hasNextPage ?? false; // ✅ server truth
      if (hasMore.value) _page++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refresh() => loadInitial();

  void reset() {
    items.clear();
    _page = 1;

    hasMore.value = true; // ✅ correct reactive variable

    isLoading.value = false;
    isLoadingMore.value = false;
    error.value = '';
  }

  void dispose() {
    items.close();
    isLoading.close();
    isLoadingMore.close();
    hasMore.close();
    error.close();
  }
}

// ✅ wrapper so Paginator stays generic over any model
class PaginatedResult<T> {
  final List<T> data;
  final PaginationMeta? meta;

  PaginatedResult({required this.data, this.meta});
}
