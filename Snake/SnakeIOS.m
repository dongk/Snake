//
//  SnakeIOS.m
//  Snake
//
//  Created by dongk on 29/6/13.
//
//

#import "SnakeIOS.h"

@interface SnakeIOS ()

@end

@implementation SnakeIOS


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initUI];

}

-startClickHandler
{
    UIButton *startBtn = (UIButton *)[self.view viewWithTag:101];
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(move)userInfo:nil repeats:YES];
        [startBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_timer invalidate];
        _timer = nil;
        [startBtn setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    }
}

-reloadClickHandler
{
    [self initUI];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * oneTouch = [touches anyObject];
    CGPoint  point = [oneTouch locationInView:self.view];
    
    [self changeDirect:point];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-initUI{
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [_tailArray removeAllObjects];
    _head = nil;
    _target = nil;
    [_timer invalidate];
    _timer = nil;
    
    _tailArray = [[NSMutableArray alloc]initWithCapacity:0];
    _head = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
    _head.backgroundColor = [UIColor redColor];
    [self.view addSubview:_head];
    [self addTail];
    for(int i=0;i<10;i++){
        [self addTail];
    }
    
    _direction = 3;
    _target = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 10, 10)];
    _target.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_target];
    
    UIImageView *reload = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reload.png"]];
    reload.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-50, 30, 30);
    
    UIButton* startBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-50, 30, 30)];
    [startBtn setTag:101];
    [startBtn setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    SEL eventHandler = @selector(startClickHandler);
    [startBtn addTarget:self action:eventHandler forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton* reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-50, 30, 30)];
    [reloadBtn setTag:102];
    [reloadBtn setImage:[UIImage imageNamed:@"reload.png"] forState:UIControlStateNormal];
    SEL eventHandler1 = @selector(reloadClickHandler);
    [reloadBtn addTarget:self action:eventHandler1 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];
}
-addTail
{
    int x =0,y=0;
    if([_tailArray count] == 0)
    {
        x = _head.frame.origin.x;
        y = _head.frame.origin.y-10;
    }
    else
    {
        x = _head.frame.origin.x;
        y = _head.frame.origin.y;
    }
    UIView *tail = [[UIView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
    tail.backgroundColor = [UIColor blackColor];
    
    [_tailArray addObject:tail];
    [self.view addSubview:tail];
}

//  定时器调用
-move
{
    int hx,hy;
    if(_direction == 1)
    {
        hx = _head.frame.origin.x;
        hy = _head.frame.origin.y-10;
    }
    else if(_direction == 2)
    {
        hx = _head.frame.origin.x+10;
        hy = _head.frame.origin.y;
    }else if(_direction == 3)
    {
        hx = _head.frame.origin.x;
        hy = _head.frame.origin.y+10;
    }else if(_direction == 4)
    {
        hx = _head.frame.origin.x-10;
        hy = _head.frame.origin.y;
    }

    UIView *tail = [_tailArray lastObject];
    [tail setFrame:CGRectMake(_head.frame.origin.x, _head.frame.origin.y, 10, 10)];
    [self.view addSubview:tail];
    [_tailArray removeLastObject];
    [_tailArray insertObject:tail atIndex:0];
    [_head setFrame:CGRectMake(hx,hy, 10, 10)];
    [self.view addSubview:_head];
    
    [self isHitSelf];
    [self isHitTarget];
    [self isBeyondBoundary];
    
    
}

-(void)changeDirect:(CGPoint )point
{
    if(_direction == 1 || _direction == 3)
    {
        if(point.x>_head.frame.origin.x){
            _direction = 2;
        }else{
            _direction = 4;
        }
    }
    else if(_direction == 2 || _direction == 4)
    {
        if(point.y<_head.frame.origin.y){
            _direction = 1;
        }else{
            _direction = 3;
        }
    }

}

-isHitTarget
{
    if(_head.frame.origin.x == _target.frame.origin.x && _head.frame.origin.y == _target.frame.origin.y){
        UIView *tail = [[UIView alloc] initWithFrame:CGRectMake(_target.frame.origin.x, _target.frame.origin.y, 10, 10)];
        tail.backgroundColor = [UIColor blackColor];
        [_tailArray insertObject:tail atIndex:0];
        [self.view addSubview:tail];

        int lowerBound = 0;
        int upperBound = self.view.frame.size.width/10;
        int x = (lowerBound + arc4random() % (upperBound - lowerBound))*10;
        upperBound = self.view.frame.size.height/10;
        int y = (lowerBound + arc4random() % (upperBound - lowerBound))*10;
        [_target setFrame:CGRectMake(x, y, 10, 10)];
        [self.view addSubview:_target];
    }
}

-isHitSelf
{
    for(UIView *tail in _tailArray){
        if(tail.frame.origin.x == _head.frame.origin.x && tail.frame.origin.y == _head.frame.origin.y){
            [_timer invalidate];
        }
    }
}

-isBeyondBoundary
{
    if(_head.frame.origin.x <0 ){
        [_head setFrame:CGRectMake(self.view.frame.size.width, _head.frame.origin.y, 10, 10)];
        [self.view addSubview:_head];
    }else if(_head.frame.origin.x> self.view.frame.size.width){
        [_head setFrame:CGRectMake(0, _head.frame.origin.y, 10, 10)];
        [self.view addSubview:_head];
    }
    if(_head.frame.origin.y <0){
        [_head setFrame:CGRectMake(_head.frame.origin.x,self.view.frame.size.height, 10, 10)];
        [self.view addSubview:_head];
    }else if( _head.frame.origin.y> self.view.frame.size.height){
        [_head setFrame:CGRectMake(_head.frame.origin.x, 0, 10, 10)];
        [self.view addSubview:_head];
    }
}

@end
