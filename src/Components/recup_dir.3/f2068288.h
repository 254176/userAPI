*,
*::before,
*::after {
	margin: 0;
	padding: 0;
	box-sizing: inherit;
	

	outline:0 none !important;
} 

html {
	box-sizing: border-box;
	font-size: 62.5%; /* 10px / 16px -> 62.5% -> 1rem -> 10px */
	
} 

html,
body,
#react_root {
	position: relative;
	
	
  
	font-weight: 400;	
	font-family: 'Kanit', sans-serif;
	
	
	font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    -webkit-font-smoothing: antialiased;
	font-weight: lighter !important;
	
	width: 100vw;
	height: 100vh;
	
	top: 0px;
	left: 0px;
} 

textarea::-webkit-input-placeholder {
  color: rgba(159, 52, 52, .5);
}

textarea:-moz-placeholder { /* Firefox 18- */
  color: rgba(159, 52, 52, .5);  
}

textarea::-moz-placeholder {  /* Firefox 19+ */
  color: rgba(159, 52, 52, .5);
}

textarea:-ms-input-placeholder {
  color: rgba(159, 52, 52, .5);  
}

textarea::placeholder {
  color: rgba(159, 52, 52, .5);  
}

.flex-row-filler {
	flex-grow: 1;
}
