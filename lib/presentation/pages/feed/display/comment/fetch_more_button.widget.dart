part of "display_feed_comment.page.dart";

class FetchMoreButtonWidget extends StatefulWidget {
  const FetchMoreButtonWidget({super.key});

  @override
  State<FetchMoreButtonWidget> createState() => _FetchMoreButtonWidgetState();
}

class _FetchMoreButtonWidgetState extends State<FetchMoreButtonWidget> {
  _handleFetchMore() {
    context.read<DisplayFeedCommentBloc>().add(FetchFeedCommentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayFeedCommentBloc, DisplayFeedCommentState>(
        builder: (context, state) {
      if (state.isFetching) {
        return const Center(child: CircularProgressIndicator());
      }
      // 마지막 페이지인 경우
      else if (state.isEnd) {
        return const SizedBox(height: 60);
      }
      // 더 가져올 수 있는 경우
      else if (!state.isEnd) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ElevatedButton(
              onPressed: _handleFetchMore, child: const Text("Fetch More")),
        );
      }
      // Else - 로딩중이거나 에러인 경우
      else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text("Error",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error)),
        );
      }
    });
  }
}
