// Copyright 2015 The go-blockchain Authors
// This file is part of the go-blockchain library.
//
// The go-blockchain library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-blockchain library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-blockchain library. If not, see <http://www.gnu.org/licenses/>.

package downloader

type DoneEvent struct{}
type StartEvent struct{}
type FailedEvent struct{ Err error }
