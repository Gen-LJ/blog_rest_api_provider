import 'package:blog_rest_api_provider/provider/update_post/update_provider.dart';
import 'package:blog_rest_api_provider/provider/update_post/update_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateScreen extends StatefulWidget {
  final int id;
  const UpdateScreen({super.key, required this.id,});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update your Content'),
          centerTitle: true,
        ),
        body: Consumer<UpdateNotifier>(builder: (_, updateNotifier, __) {
          UpdateState updateState = updateNotifier.updateState;
          if(updateState is UpdateLoadingState){
            return LinearProgressIndicator();
          }
          if(updateState is UpdateSuccess){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(updateState.updateResponse.result?? ''),
                Divider(),
                ElevatedButton(onPressed:(){
                  Navigator.pop(context,'update success');
                  updateNotifier.updateState = UpdateFormState();
                }, child: const Text('Ok'))
              ],
            );
          }
          if(updateState is UpdateFailed){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(updateState.errorMessage),
                Divider(),
                ElevatedButton(onPressed: (){
                  updateNotifier.tryAgain();
                }, child: Text('Try again'))
              ],
            );
          }
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  child: Column(children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Update  Blog Title'),
                ),
                const Divider(),
                TextField(
                  minLines: 3,
                  maxLines: 5,
                  controller: _bodyController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Update Blog content'),
                ),
                    Divider(),
                    ElevatedButton(onPressed: (){
                      if(_titleController.text.isNotEmpty && _bodyController.text.isNotEmpty){
                        String title = _titleController.text;
                        String body =_bodyController.text;
                        int id = widget.id;
                        if(mounted){
                          Provider.of<UpdateNotifier>(context,listen: false).update(id: id, title: title, body: body);
                        }
                      }
                      else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Please Enter Title and content')));
                      }
                    }, child: Text('Update'))
              ])));
        }));
  }
}