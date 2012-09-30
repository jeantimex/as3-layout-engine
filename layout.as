package
{
	import flash.display.MovieClip;
	
	public class layout extends MovieClip
	{
		private var sizeW:int = 10;
		private var sizeH:int = 8;
		private var gridW:Number = 90;
		private var gridH:Number = 60;
		
		private var grid:Grid;
		private var blocks:Array = [ { x:0, y:0, w:gridW, h:gridH }, { x:300, y:160, w:gridW, h:gridH }, { x:600, y:320, w:gridW, h:gridH } ];
		
		/**
		 * Constructor
		 */
		public function layout()
		{
			
			// Create a grid
			grid = new Grid();
			
			grid.init( {
				x: 10,
				y: 110,
				sizeW: sizeW,
				sizeH: sizeH,
				gridW: gridW,
				gridH: gridH
			} );
			
			for (var i:int = 0; i < blocks.length; ++i) {
				var block:Block = new Block();
				
				block.id = String( i );
				block.container = grid;
				block.init( blocks[i] );
				
				grid.addBlock( block );
			}
			
			addChild( grid );
			
		}
	}
}