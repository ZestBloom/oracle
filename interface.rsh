"reach 0.1";
"use strict";

import { transferUntrackedTokenAmountToAddr } from "./util.rsh";

// -----------------------------------------------
// Name: Interface Template
// Description: NP Rapp simple
// Author: Nicholas Shellabarger
// Version: 0.1.0 - oracle initial
// Requires Reach v0.1.7 (stable)
// -----------------------------------------------
export const Participants = () => [
  Participant("Manager", {
    getParams: Fun(
      [],
      Object({
        addr: Address, 
        token: Token, // ex goETH
        amount: UInt, // ALGO per unit
      })
    ),
  }),
  Participant("Relay", {}),
];
export const Views = () => [
  View({
    token: Token, // ex goETH
    amount: UInt, // ALGO per unit
    controller: Address, // ALGO per unit
  }),
];
export const Api = () => [
  API({
    touch: Fun([], Null), //
    grant: Fun([Address], Null), // grant update update permission to new controller
    update: Fun([UInt], Null), // update amount
    close: Fun([], Null),
  }),
];
export const App = (map) => {
  const [[Manager, Relay], [v], [a]] = map;
  Manager.only(() => {
    const { token: tok, amount: amt, addr } = declassify(interact.getParams());
  });
  Manager.publish(tok, amt, addr);
  v.token.set(tok);
  v.controller.set(Manager);
  v.amount.set(amt);
  // ---------------------------------------------
  const [keepGoing, controller, amount] = parallelReduce([true, Manager, amt])
    .define(() => {
      v.controller.set(controller);
      v.amount.set(amount);
    })
    .invariant(balance() >= 0)
    .while(keepGoing)
    // -------------------------------------------
    .api(
      a.touch,
      () => assume(true),
      () => 0,
      (k) => {
        require(true);
        transferUntrackedTokenAmountToAddr(tok, addr);
        k(null);
        return [true, controller, amount];
      }
    )
    // -------------------------------------------
    .api(
      a.update,
      (_) => assume(true),
      (_) => 0,
      (m, k) => {
        require(true);
        transferUntrackedTokenAmountToAddr(tok, addr);
        k(null);
        return [true, controller, m];
      }
    )
    // -------------------------------------------
    .api(
      a.grant,
      (_) => assume(true),
      (_) => 0,
      (m, k) => {
        require(true);
        transferUntrackedTokenAmountToAddr(tok, addr);
        k(null);
        return [true, m, amount];
      }
    )
    // -------------------------------------------
    .api(
      a.close,
      () => assume(true),
      () => 0,
      (k) => {
        require(true);
        transferUntrackedTokenAmountToAddr(tok, addr);
        k(null);
        return [false, controller, amount];
      }
    )
    // -------------------------------------------
    .timeout(false);
  // ---------------------------------------------
  commit();
  Relay.publish();
  transfer(balance()).to(Relay);
  transfer(balance(tok), tok).to(Relay);
  commit();
  exit();
  // ---------------------------------------------
};
// -----------------------------------------------
