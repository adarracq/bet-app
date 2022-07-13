const MyAppName = artifacts.require("MyAppName") ;
  
contract("MyAppName" , () => {
    it("Hello World Testing" , async () => {
       const helloWorld = await MyAppName.deployed() ;
       await helloWorld.setName("User Name") ;
       const result = await helloWorld.yourName() ;
       assert(result === "User Name") ;
    });
});