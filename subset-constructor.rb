#!/usr/bin/env ruby 
# coding: utf-8
# ===============================================================
#
# Filename:	subset-constructor.rb
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-11-14 02:50:53 CST]
# Last-update:	2014-11-14 02:50:53 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# License: 
# Copyright (c) 2013 Oxnz
#
# Distributed under terms of the [LICENSE] license.
# [license]
#
# ===============================================================
#
# page 35

class FA
  def initialize all_states, input_chars, transfer_func, initial_state, accepted_states
    @all_states = all_states
    @input_chars = input_chars
    @transfer_func = transfer_func
    @initial_state = initial_state
    @accepted_states = accepted_states
  end

  def all_states
    @all_states
  end

  def input_chars
    @input_chars
  end

  def transfer state, char
    @transfer_func[state][char]
  end

  def initial_state
    @initial_state
  end

  def accepted_states
    @accepted_states
  end
end

class NFA < FA
  EPSILON = 'e'
  def initialize
    super all_states, input_chars, transfer_func, initial_state, accepted_states
  end
end

class DFA < FA
  def initialize all_states, input_chars, transfer_func, initial_state, accepted_states
    super all_states, input_chars, transfer_func, initial_state, accepted_states
  end
end

def epsilon_closure sigma
end

all_states = [:n0, :n1, :n2, :n3, :n4, :n5, :n6, :n7, :n8, :n9]
input_chars = 'abc'.split
transfer_func = ->(state, input) {
  case state
  when :n0
    { 'a': n1 }[input] or errpro
  when :n1
    { NFA::EPSILON : [:n1, :n2, :n3, :n4, :n6, :n9] }
}

nfa = NFA.new 

#n0 = 0
#q0 = epsilon_closure([n0])
#Q = q0
#WorkList = [q0]
#
#while not WorkList.empty?
#  q = WorkList.pop
#  for c in sigma
#    t = epsilon_closure delta(q, c)
#    T[q,c] = t
#    if not Q.contains? t
#      Q << t
#      WorkList << t
#    end
#  end
#end
