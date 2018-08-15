//Decorator

(
Window.closeAll;
w = Window("flow", Rect(850,50,400,400))
.front
.alwaysOnTop_(true);

w.view.decorator_(FlowLayout(w.bounds, 15@15, 7@7));

)

w.view.decorator.nextLine;

20.do{Knob(w,40@40)};

w.view.children.collect(_.remove);

w.close;

//Composite View

(
Window.closeAll;
w = Window("nested", Rect(750,50,500,500))
.front
.alwaysOnTop_(true);

w.view.decorator_(FlowLayout(w.bounds, 30@30, 30@30));

c = Array.fill(4,{
	arg view;
	view = CompositeView(w,200@200)
	.background_(Color.rand);

	view.decorator_(FlowViewLayout(view.bounds, 5@5, 5@5))
});

Array.fill(4,{Slider(c[0], 30@150)});
Array.fill(8,{Knob(c[3], 40@40)});

)


c[0].children[3].value_(0.5);