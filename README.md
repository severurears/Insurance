# Insurance Smart Contract
This smart contract automatically claims flight insurance payouts from an insurance provider when the client's flight has been delayed. It can be used to onboard a client and immediately claim a payout as soon as the client boards.

#Functions
- Client onboarding
- Boarding declaration
- Insurance status check

# How it works
1) You onboard a client by providing their name, NRIC, flight code, planned takeoff date time, and value of contract.
2) Next, once the client is onboarded, a unique contract ID (address) is generated.
3) This ID can be used by the client to check the status of their flight insurance, and will also be used to declare that the client has boarded their flight.
4) Once the boarding has been declared, the smart contract will automatically check if their flight has been delayed by comparing their boarding time with the initially planned takeoff date and time.
5) If the flight has been delayed, the client will receive an automatic payout.
