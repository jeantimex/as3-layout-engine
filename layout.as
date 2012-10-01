package
{
	import flash.display.MovieClip;
	
	import com.jeantimex.as3.layout.Block;
	import com.jeantimex.as3.layout.Grid;
	
	/**
	 * Demo document class
	 * 
	 * @author Yong Su
	 * @date 09/30/2012
	 */
	public class layout extends MovieClip
	{
		/**
		 * Define how many cells in a grid and the size for each cell
		 */
		private var sizeW:int = 10;
		private var sizeH:int = 8;
		private var cellW:Number = 90;
		private var cellH:Number = 60;
		
		/**
		 * Sample grid and blocks
		 */
		private var grid:Grid;
		private var blocks:Array = [ { x:0, y:0, w:cellW, h:cellH }, { x:360, y:180, w:cellW, h:cellH }, { x:540, y:240, w:cellW, h:cellH } ];
		
		/**
		 * Constructor
		 */
		public function layout()
		{
			// Create a sample grid
			grid = new Grid();
			
			// Initialize the grid
			grid.init( {
				x: 10,
				y: 110,
				sizeW: sizeW,
				sizeH: sizeH,
				cellW: cellW,
				cellH: cellH
			} );
			
			// Add sample blocks to the grid
			for (var i:int = 0; i < blocks.length; ++i) {
				var block:Block = new Block();
				
				block.id = String( i );
				block.container = grid;
				block.init( blocks[i] );
				
				grid.addBlock( block );
			}
			
			// Add grid to the stage
			addChild( grid );
			
		}
	}
}