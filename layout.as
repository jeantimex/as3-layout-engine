package
{
	import flash.display.MovieClip;
	
	public class layout extends MovieClip
	{
		public var grid:Grid;
		
		private var blocks:Array;
		private var initPositions:Array = [ { x:0, y:0 }, { x:300, y:160 }, {x:600, y:320} ];
		
		/**
		 * Constructor
		 */
		public function layout()
		{
			blocks = new Array();
			
			for (var i:int = 0; i < initPositions.length; ++i) {
				var block:Block = new Block( grid );
				block.x = initPositions[i].x;
				block.y = initPositions[i].y;
				grid.addChild( block );
			}
			
		}
	}
}