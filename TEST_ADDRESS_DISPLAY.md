# Address Display Fix - Testing Guide

## Understanding the Fix:
The fix ensures that:
1. During address loading, "Loading..." is shown instead of stale addresses
2. In guest mode (or when not logged in), address is read from localStorage
3. No old/stale addresses like "peshawer" appear during loading

## Testing Steps:

### Test 1: Address Loading State (After Login)
1. ✅ Clear app cache/data
2. ✅ Complete onboarding  
3. ✅ Login with test account
4. ✅ On home screen, observe address field:
   - Should show "Loading..." briefly during initial load
   - Then shows saved address or "No address"
   - Should NOT show stale addresses like "peshawer"

### Test 2: Address Selection & Display
1. ✅ Login to app
2. ✅ Click on address field in home screen
3. ✅ Select/change address from map
4. ✅ Verify address displays correctly
5. ✅ Hot reload app
6. ✅ Address should persist and display correctly

### Test 3: After Logout (Clearing State)
1. ✅ Login and verify address displays
2. ✅ Logout from account
3. ✅ Login again
4. ✅ Address should load fresh (not show old cached address)

### Expected Behavior:
- ✅ Loading state shows "Loading..." (not stale addresses)
- ✅ Address from localStorage displays correctly
- ✅ No stale addresses shown during loading transitions
- ✅ Address persists correctly after hot reload

## Note:
Since the app requires login to access home screen, testing is done after login. The fix improves address loading behavior for all scenarios (logged in or guest checkout flows).

