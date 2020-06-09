import 'package:flutter/material.dart';
import 'package:nsb/framework.dart/popUp.dart';
class MenusGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: new Center(child:new Text('NSB'), 
        ),
        elevation: 0,
        actions: <Widget>[
              PopUpPage(),
              ],
        ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomLeft:  const  Radius.circular(80.0),
                    bottomRight: const  Radius.circular(80.0)),
                color: Colors.deepPurple
              ),
              height: 200,
            ),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                  child:_generateUI(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0
                  ),
                  delegate: SliverChildBuilderDelegate(
                    _buildCategoryItem,
                  )

                ),
              ),
            ],
          ),
        ],
      ),
    // drawer:LoginDrawer(),
    );
  }
   Widget _generateUI()
   {
     return Container(
       height:100 ,
       child:new Center(child:new Column(
         children: <Widget>[
           new Text("Mg Aung Min",style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              height: 2.0,
              fontWeight: FontWeight.w600),),

           new Text("10,000,000 MMK",style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              height: 2.0,
              fontWeight: FontWeight.w600),),
         ],
       ),)
     );
   }
   Widget _buildCategoryItem(BuildContext context, int index) {
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () =>{},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        ],
      ),
    );
  }

  }