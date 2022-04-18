"reach 0.1";
"use strict";
// -----------------------------------------------
// Name: Interface Template
// Description: NP Rapp simple
// Author: Nicholas Shellabarger
// Version: 0.1.0 - oracle initial
// Requires Reach v0.1.7 (stable)
// ----------------------------------------------
export const Participants = () => [
  Participant("Manager", {
    getParams: Fun([], Object({
      token: Token, // ex goETH
      amount: UInt, // ALGO per unit
    })),
  }),
  Participant("Relay", {}),
];
export const Views = () => [
  View({
    token: Token, // ex goETH
    amount: UInt, // ALGO per unit
  }),
];
export const Api = () => [
  /*
  API({
    grant: Fun([], Null), // grant update update permission to new controller
    update: Fun([UInt], Null), // update amount
  }),
  */
];
export const App = (map) => {
  const [[Manager, Relay], [v], _] = map;
  Manager.only(() => {
    const { token, amount } = declassify(interact.getParams());
  });
  Manager.publish(token, amount);
  v.token.set(token);
  v.amount.set(amount);
  // ---------------------------------------------
  // TODO allow manager or controller to update amount
  // ---------------------------------------------
  /*
  const [keepGoing, controller, amount] = parallelReduce([true, Manager, 0])
    .define(() => {
      v.controller.set(controller);
      v.amount.set(amount);
    })
    .invariant(balance() >= 0)
    .while(keepGoing)
    .api(
      a.touch,
      () => assume(true),
      () => 0,
      (k) => {
        require(true);
        k(null);
        return [true, controller, amount];
      }
    )
    .api(
      a.deposit,
      //(_) => assume(this == Manager && this == controller),
      (_) => assume(true),
      (m) => m,
      (m, k) => {
        //require(this == Manager && this == controller);
        require(true);
        k(null);
        return [true, controller, amount + m];
      }
    )
    // give control to another account
    .api(
      a.unlock,
      //(_) => assume(this == controller),
      (_) => assume(true),
      (_) => 0,
      (m, k) => {
        //require(this == controller);
        require(true);
        k(null);
        return [true, m, amount];
      }
    )
    // swap controllers
    .api(
      a.swap,
      //(_) => assume(this == controller),
      (_) => assume(true),
      (_) => 0,
      (m, k) => {
        //require(this == controller);
        require(true);
        k(Manager);
        return [false, m, amount];
      }
    )
    .api(
      a.close,
      //() => assume(this == controller && this == Manager),
      () => assume(true),
      () => 0,
      (k) => {
        //require(this == controller && this == Manager);
        require(true);
        k(null);
        return [false, controller, amount];
      }
    )
    .timeout(false);
  */
  // ---------------------------------------------
  commit();
  Relay.publish();
  //transfer(balance()).to(controller);
  commit();
  exit();
};
// ----------------------------------------------
