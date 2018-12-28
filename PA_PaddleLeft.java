public class PaddleLeft {
	private int yPos = 0;
	final int xPos = 60;
	
	public PaddleLeft() {
		setPos(230);
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
