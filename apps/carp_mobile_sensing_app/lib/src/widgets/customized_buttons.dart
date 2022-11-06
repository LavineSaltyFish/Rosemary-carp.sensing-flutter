part of mobile_sensing_app;

class IconButtonCustomized extends StatelessWidget {
  const IconButtonCustomized({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: <Widget>[
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxHeight,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              // borderRadius: borderRadius,
            ),
            child: Row(children: <Widget>[
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              OutlinedButton(
                  onPressed: null,
                  child: Text("haha")
              ),
            ]),
          );
        })
      ]),
    );
  }
}
