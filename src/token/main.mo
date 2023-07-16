import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";


actor Token {

  let owner: Principal = Principal.fromText("jshpo-kmeec-b2q4g-5nh7t-75dfl-26dbw-37aok-ekbft-oyhhh-4f6k7-iqe");
  let totalSupply: Nat = 1000000000;
  let symbol: Text = "OCT";

  private stable var balanceEntries: [(Principal, Nat)] = [];
  private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
  if(balances.size() < 1) {
    balances.put(owner, totalSupply);
  };

  public query func balanceOf(who: Principal): async Nat {

    let balance: Nat = switch (balances.get(who)) {
      case null 0;
      case (?result) result;
    };

    return balance;
  };

  public query func tokenSymbol():async Text {
    return symbol;
  };

  public shared(msg) func payOut(): async Text {
    // Debug.print(debug_show(msg.caller));

    if(balances.get(msg.caller) == null) {
      let amount = 10000;
      let result = await transfer(msg.caller, amount);
      return result;
    } else {
      return "Already claimed";
    }
    
  };

  public shared(msg) func transfer(to: Principal, amount: Nat): async Text {
    let fromBalance = await balanceOf(msg.caller);
    let toBalance = await balanceOf(to);

    if(fromBalance > amount) {
      balances.put(msg.caller, fromBalance - amount);
      balances.put(to, toBalance + amount);

      return "Success";
    } else {
      return "Insufficient funds";
    }
  };

  system func preupgrade() {
    balanceEntries := Iter.toArray(balances.entries());
  };

  system func postupgrade() {
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    if(balances.size() < 1) {
      balances.put(owner, totalSupply);
    }
  };

}