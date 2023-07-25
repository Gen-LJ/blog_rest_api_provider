

import 'package:blog_rest_api_provider/data/model/get_all_post_response.dart';
import 'package:blog_rest_api_provider/provider/get_all_posts/get_all_post_state.dart';
import 'package:blog_rest_api_provider/provider/get_all_posts/get_all_provider.dart';
import 'package:blog_rest_api_provider/ui/screen/blog_post_detail_screen.dart';
import 'package:blog_rest_api_provider/ui/screen/blog_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllPost(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Api Lesson'),
        centerTitle: true
      ),
      body: Consumer<GetAllPostNotifier> (
        builder: (_,getAllProvider,__){
          GetAllPostState getAllPostState = getAllProvider.getAllPostState;
          if(getAllPostState is GetAllPostSuccess){
            List<GetAllPostResponse> getAllPostResponseList = getAllPostState.getAllPostList;
            return RefreshIndicator(
              onRefresh: () async{
                 _getAllPost(context);
              },
              child: ListView.builder(
                itemCount: getAllPostResponseList.length,
                  itemBuilder: (context,position){
                  GetAllPostResponse getAllPostResponse = getAllPostResponseList[position];
                  return InkWell(
                    onTap: ()  {
                      if(getAllPostResponse.id != null) {
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>BlogPostDetailScreen(id: getAllPostResponse.id!)));
                      }
                    },
                    child: Card(
                      child: ListTile(
                        title: Text('${getAllPostResponse.title}'),
                      ),
                    ),
                  );
                  }),
            );
          }
          else if(getAllPostState is GetAllPostFailed){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('OOPS Somethings wrong'),
                Divider(),
                ElevatedButton(onPressed: (){
                  _getAllPost(context);
                }, child: Text('Try Again'))
              ],
            );
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_)=>
          BlogUploadScreen()));
          if(result != null && result == 'success'){
            if(mounted) {
              _getAllPost(context);
            }
          }
        },child: Icon(Icons.add),
      ),
    );
  }
  void _getAllPost(BuildContext ctx){
    Provider.of<GetAllPostNotifier>(context,listen: false).getAllPost();
  }
}
