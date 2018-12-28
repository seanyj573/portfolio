import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

public class HandlerClass implements MouseListener {

	GridConstructor gc = new GridConstructor();

	static int clickCount = 0;
	static boolean listenerOn = true;
	static boolean noValue1 = true;
	static boolean noValue2 = true;
	static boolean noValue3 = true;
	static boolean noValue4 = true;
	static boolean noValue5 = true;
	static boolean noValue6 = true;
	static boolean noValue7 = true;
	static boolean noValue8 = true; 
	static boolean noValue9 = true;

	//Mouse listener events
	@Override
	public void mouseClicked(MouseEvent e) {
		if(listenerOn) {
			if(gc.s1.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue1) {
					WindowConstructor.TickSet(gc.s1.x, gc.s1.y);
					WinnerClass.findWinner(true, 1);
					noValue1 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue1) {
					WindowConstructor.ToeSet(gc.s1.x, gc.s1.y);
					WinnerClass.findWinner(false, 1);
					noValue1 = false;
					clickCount++;
				}
			}

			if(gc.s2.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue2) {
					WindowConstructor.TickSet(gc.s2.x, gc.s2.y);
					WinnerClass.findWinner(true, 2);
					noValue2 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue2) {
					WindowConstructor.ToeSet(gc.s2.x, gc.s2.y);
					WinnerClass.findWinner(false, 2);
					noValue2 = false;
					clickCount++;
				}
			}

			if(gc.s3.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue3) {
					WindowConstructor.TickSet(gc.s3.x, gc.s3.y);
					WinnerClass.findWinner(true, 3);
					noValue3 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue3) {
					WindowConstructor.ToeSet(gc.s3.x, gc.s3.y);
					WinnerClass.findWinner(false, 3);
					noValue3 = false;
					clickCount++;
				}
			}

			if(gc.s4.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue4) {
					WindowConstructor.TickSet(gc.s4.x, gc.s4.y);
					WinnerClass.findWinner(true, 4);
					noValue4 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue4) {
					WindowConstructor.ToeSet(gc.s4.x, gc.s4.y);
					WinnerClass.findWinner(false, 4);
					noValue4 = false;
					clickCount++;
				}
			}

			if(gc.s5.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue5) {
					WindowConstructor.TickSet(gc.s5.x, gc.s5.y);
					WinnerClass.findWinner(true, 5);
					noValue5 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue5) {
					WindowConstructor.ToeSet(gc.s5.x, gc.s5.y);
					WinnerClass.findWinner(false, 5);
					noValue5 = false;
					clickCount++;
				}
			}

			if(gc.s6.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue6) {
					WindowConstructor.TickSet(gc.s6.x, gc.s6.y);
					WinnerClass.findWinner(true, 6);
					noValue6 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue6) {
					WindowConstructor.ToeSet(gc.s6.x, gc.s6.y);
					WinnerClass.findWinner(false, 6);
					noValue6 = false;
					clickCount++;
				}
			}

			if(gc.s7.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue7) {
					WindowConstructor.TickSet(gc.s7.x, gc.s7.y);
					WinnerClass.findWinner(true, 7);
					noValue7 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue7) {
					WindowConstructor.ToeSet(gc.s7.x, gc.s7.y);
					WinnerClass.findWinner(false, 7);
					noValue7 = false;
					clickCount++;
				}
			}

			if(gc.s8.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue8) {
					WindowConstructor.TickSet(gc.s8.x, gc.s8.y);
					WinnerClass.findWinner(true, 8);
					noValue8 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue8) {
					WindowConstructor.ToeSet(gc.s8.x, gc.s8.y);
					WinnerClass.findWinner(false, 8);
					noValue8 = false;
					clickCount++;
				}
			}

			if(gc.s9.contains(e.getPoint())) {
				if((clickCount % 2) == 0 && noValue9) {
					WindowConstructor.TickSet(gc.s9.x, gc.s9.y);
					WinnerClass.findWinner(true, 9);
					noValue9 = false;
					clickCount++;
				} else if((clickCount % 2) != 0 && noValue9) {
					WindowConstructor.ToeSet(gc.s9.x, gc.s9.y);
					WinnerClass.findWinner(false, 9);
					noValue9 = false;
					clickCount++;
				}
			}
		}
	}

	@Override
	public void mousePressed(MouseEvent e) {
	}

	@Override
	public void mouseReleased(MouseEvent e) {
	}

	@Override
	public void mouseEntered(MouseEvent e) {
	}

	@Override
	public void mouseExited(MouseEvent e) {
	}
}
