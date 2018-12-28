public class PaddleRightAI {
	private int yPos = 0;
	final int xPos = 920;
	
	public PaddleRightAI(int ballPos) {
		setPos(ballPos + 10);
	}
	
	public void setPos(int pos) {
		this.yPos = pos;
		
		if(yPos > 460) {
			setPos(460);
		} else if(yPos < 0) {
			setPos(0);
		}
	}
	
	public int getPos() {
		return yPos;
	}
}
