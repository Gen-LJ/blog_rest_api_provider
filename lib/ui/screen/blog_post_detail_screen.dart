import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/get_complete_post/get_complete_post_notifier.dart';
import 'package:blog_rest_api_provider/ui/screen/update_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/get_one_post_response.dart';
import '../../provider/get_all_posts/get_all_provider.dart';
import '../../provider/get_complete_post/get_complete_post_state.dart';

class BlogPostDetailScreen extends StatefulWidget {
  const BlogPostDetailScreen({super.key, required this.id});
  final int id;

  @override
  State<BlogPostDetailScreen> createState() => _BlogPostDetailScreenState();
}

class _BlogPostDetailScreenState extends State<BlogPostDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getBlogDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GetCompletePostNotifier>(
            builder: (_, getCompletePostNotifier, __) {
          GetCompletePostState getCompletePostState =
              getCompletePostNotifier.getCompletePostState;
          if (getCompletePostState is GetCompletePostSuccess) {
            GetOnePostResponse getOnePostResponse =
                getCompletePostState.getOnePostResponse;
            return Text(getOnePostResponse.title ?? '');
          } else if (getCompletePostState is GetCompletePostFailed) {
            return Text(getCompletePostState.errorMessage);
          }
          return DotsIndicator(
            dotsCount: 5,
            decorator: const DotsDecorator(
                activeColor: Colors.blue, color: Colors.white),
          );
        }),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>  UpdateScreen(id: widget.id,)));
              if(result != null && result == 'update success'){
                if(mounted) {
                  _getBlogDetail(widget.id);
                  _getAllPost(context);
                }
              }
            },
            style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return 0;
                }
                return 0;
              },
            )),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.update), Text('Update')],
            ),
          )
        ],
      ),
      body: Consumer<GetCompletePostNotifier>(
        builder: (_, getCompletePostNotifier, __) {
          GetCompletePostState getCompletePostState =
              getCompletePostNotifier.getCompletePostState;
          if (getCompletePostState is GetCompletePostSuccess) {
            GetOnePostResponse getOnePostResponse =
                getCompletePostState.getOnePostResponse;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(getOnePostResponse.body ?? ''),
                    const Divider(),
                    if (getOnePostResponse.photo != null)
                      CachedNetworkImage(
                          imageUrl:
                              '${BlogApiService.baseUrl}${getOnePostResponse.photo}')
                  ],
                ),
              ),
            );
          } else if (getCompletePostState is GetCompletePostFailed) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getCompletePostState.errorMessage),
                const Divider(),
                ElevatedButton(
                    onPressed: () {
                      _getBlogDetail(widget.id);
                    },
                    child: const Text('Try Again'))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _getBlogDetail(int id) {
    Provider.of<GetCompletePostNotifier>(context, listen: false)
        .getCompletePost(id: id);
  }
  void _getAllPost(BuildContext ctx){
    Provider.of<GetAllPostNotifier>(context,listen: false).getAllPost();
  }

}
