public class Ball {
	private int xPos;
	private int yPos;
	public int dx;
	public int dy;
	public int rand;
	boolean isStill = true;
	
	public Ball() {
		setPos(490, 290);
	}
	
	public void setPos(int d, int e) {
		this.xPos = d;
		this.yPos = e;
	}
	
	public int getX() {
		return xPos;
	}
	
	public int getY() {
		return yPos;
	}
	
	public void move() {
		if(isStill) {
			randomMove();
		}
		setPos(this.getX() + dx, this.getY() + dy);
		isStill = false;
	}
	
	public void reset() {
		setPos(490, 290);
		isStill = true;
	}
	
	public void randomMove() {
		rand = (int)((Math.random() * 4) + 1);
		if(rand == 1) {
			dx = 1;
			dy = 1;
		} else if(rand == 2) {
			dx = 1;
			dy = -1;
		} else if(rand == 3) {
			dx = -1;
			dy = 1;
		} else if(rand == 4) {
			dx = -1;
			dy = -1;
		}
	}
}
