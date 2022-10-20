#!/usr/bin/env node


// generic shell-line var helpers:

var [nadepath, $0, ...args] = process.argv;
var [$1, $2, $3] = args;

if ($1 === '--debug' || $1 === '--inspect' || $1 === '--inspect-brk') {
	args.shift();
	_=require('child_process').spawnSync(
		nadepath, ['--inspect'+($1.endsWith('-brk')?'-brk':''), $0 , ...args],
	{stdio:"inherit"}).status;
	throw process.exit(_);
}

var 
	stdout  = str => process.stdout.write(str +'\n'),
	stderr  = str => process.stderr.write(str +'\n'),
	noop    = ()  => void 0,
	//freezer = o   => Object.freeze(Object.seal(o)), // hope to het somoptimosations¿ in loops. by adding this
_=0;


//

if ($1 === '--help') {
	stdout(`Usage: ${$0.replace(/^.*\//,'')} <./IN >./OUT\nnote: expects stdin to be sorted file`);
	throw process.exit(0);
}

if (args.length) {
	stdout('see --help');
	throw proces.exit(2);
}


// TODO:!! HERE
//const lib = {
//	findtree_to_obj: (_=>{
//		//var
//	})()
// 
//}



var files = require('fs').readFileSync(0).toString().split('\n');
if (!files) var files = [
'./a/b/c',
'./a/b/c2',
'./z/c',
'./z/c2',
'./x/z',
'./x/z/c',
]

function path_join(fName) {
	var path = [];
	for (let itree = this; itree['..'].name; itree = itree['..'].parrent) {
		path.unshift(itree['..'].name);
	}
	debugger
	path.join('/') + (fName ? '/'+fName : '')
}

var files_tree = Object.defineProperty({}, '..', {value:{parrent: null, dirs: [] }} );
files.forEach(v => {
	var
		o = files_tree,
		path_arr = v.split('/'),
		fName = path_arr.pop(),
		folderName = path_arr.pop(),
	_=0;
	var inner_o = o;
	for (let i of path_arr) {
		inner_o = inner_o[i];
		// if throws here probably is because STDIN is not sorted and previous folder does not exist
		// please use: `find . \( -type d -printf "%p/\n" , -type f -print \)`
	}

	if (fName) { // if file
		inner_o[folderName]['.'].push(fName)
	} else { // if dir
		var i = { '.': [] };
		inner_o[folderName] = i;
		// if throws here (read above comment for throw)

		// .. means metadata parrent folder is in tree['..'].parrent
		inner_o['..'].dirs.push([folderName, i]);
		Object.defineProperty(i, '..', {value:{
			parrent: inner_o,
			dirs: [],
			name: folderName,
			toString: path_join
		}});
		
	}
});


//console.log(JSON.stringify(files_tree,null,'\t'))


var filesTree_simular = [], filesTree_same = [];

//debugger
console.log(''+ filesTree_simular)
//never 

function find_filesTree(tree) { // TODO:! HERE
	tree['..'].dirs.forEach(a => {
		var tree = a[1]['.'];
		if (!tree) return;

		console.log()
	});
}

find_filesTree(files_tree);


console.log(JSON.stringify(filesTree_simular, null, '\t'));
console.log(JSON.stringify(filesTree_same,    null, '\t'));



{ // debugger
	Object.assign(globalThis, {
		files_tree,
		filesTree_simular,
		filesTree_same,
	})
	setTimeout(noop, Number.MAX_SIGNED32BIT = 2**31-1);


	//(async never=>await (new Promise(res=>{ })))() // node still exits
}
