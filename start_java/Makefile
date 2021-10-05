p2_java: p2_java.java lexer.java
	javac -classpath "" *.java

lexer.java: p2_java.l
	java -jar ./jflex-full-1.7.0.jar --legacydot p2_java.l 

clean:
	rm -f lexer.java lexer.java~ p2_java.class lexer.class

